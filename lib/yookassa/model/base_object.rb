# frozen_string_literal: true

require 'json'
require 'bigdecimal'

module YooKassa
  # Base class for all data objects (requests, responses and domain models).
  #
  # Provides construction from a Hash (deeply, through declared attribute
  # setters) and serialization back to a Hash / JSON string that only
  # includes attributes that are not nil.
  #
  # Mirrors yookassa.domain.common.base_object.BaseObject from the Python SDK.
  class BaseObject
    class << self
      # The ordered list of attribute names declared on this class (and inherited ones).
      def model_attributes
        @model_attributes ||= superclass.respond_to?(:model_attributes) ? superclass.model_attributes.dup : []
      end

      # Declares one or more plain attributes (reader + writer), and registers
      # them so they participate in #to_h / #to_json. A subclass is free to
      # override the generated writer afterwards to add validation/casting -
      # as long as it is defined after the `attribute` call in the class body.
      def attribute(*names)
        names.each do |name|
          name = name.to_sym
          model_attributes << name unless model_attributes.include?(name)
          attr_accessor name
        end
      end
    end

    def initialize(attributes = nil)
      @extra_attribute_names = []
      return if attributes.nil?

      assign_attributes(attributes)
    end

    # Mass-assigns attributes from a Hash-like object. Keys that do not map
    # to a declared attribute are still accepted and exposed dynamically -
    # this is what lets the generic pass-through models (Confirmation,
    # PaymentMethodData, PayoutDestination, ...) accept any documented field
    # without a dedicated Ruby class per API variant.
    def assign_attributes(attributes)
      raise TypeError, "#{self.class}.new expects a Hash, got #{attributes.class}" unless attributes.respond_to?(:each_pair)

      attributes.each_pair { |key, value| assign_attribute(key, value) }
      self
    end

    def assign_attribute(key, value)
      setter = :"#{key}="
      define_extra_attribute(key) unless respond_to?(setter)
      public_send(setter, value)
    end

    # @return [Hash] a Hash of all non-nil attributes, recursively converted.
    def to_h
      attribute_list.each_with_object({}) do |name, hash|
        value = public_send(name)
        next if value.nil?

        hash[name] = self.class.serialize(value)
      end
    end
    alias to_hash to_h

    def to_json(*args)
      JSON.generate(to_h, *args)
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end

    # No-op by default. Request objects (YooKassa::PaymentRequest and
    # friends) override this to raise ArgumentError when required fields are
    # missing or inconsistent, mirroring RequestObject#validate from the
    # Python SDK.
    def validate; end

    class << self
      # Recursively converts a value into something JSON-safe: BaseObject ->
      # Hash, Array -> Array with each element converted, BigDecimal -> String.
      def serialize(value)
        case value
        when BaseObject
          value.to_h
        when Array
          value.map { |item| serialize(item) }
        when Hash
          value.each_with_object({}) { |(k, v), h| h[k] = serialize(v) }
        when BigDecimal
          value.to_s('F')
        else
          value
        end
      end
    end

    private

    def attribute_list
      (self.class.model_attributes + @extra_attribute_names).uniq
    end

    def define_extra_attribute(key)
      name = key.to_sym
      ivar = :"@#{name}"
      @extra_attribute_names << name unless @extra_attribute_names.include?(name)

      define_singleton_method(name) { instance_variable_get(ivar) }
      define_singleton_method(:"#{name}=") do |value|
        instance_variable_set(ivar, YooKassa::BaseObject.wrap_generic(value))
      end
    end

    class << self
      # Wraps a plain Hash/Array-of-Hash value coming from an unknown
      # (pass-through) field into a YooKassa::GenericObject so that callers
      # can use dotted attribute access instead of having to know it is a Hash.
      def wrap_generic(value)
        case value
        when Hash
          YooKassa::GenericObject.new(value)
        when Array
          value.map { |item| wrap_generic(item) }
        else
          value
        end
      end
    end
  end
end
