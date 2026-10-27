# frozen_string_literal: true

require 'rbconfig'

module YooKassa
  # Represents a "Name/Version" fragment of the YM-User-Agent header.
  #
  # Mirrors yookassa.domain.common.user_agent.Version from the Python SDK.
  class Version
    PART_DELIMITER = ' '
    VERSION_DELIMITER = '/'

    attr_reader :name, :version

    def initialize(name, version)
      @name = name.to_s
      @version = version.to_s
    end

    def to_s
      clean_name = strip_edges(name).gsub(PART_DELIMITER, '.').gsub(VERSION_DELIMITER, '.')
      clean_version = strip_edges(version).gsub(PART_DELIMITER, '.').gsub(VERSION_DELIMITER, '.')
      "#{clean_name}#{VERSION_DELIMITER}#{clean_version}"
    end

    private

    def strip_edges(value)
      value.gsub(%r{\A[\s/]+}, '').gsub(%r{[\s/]+\z}, '')
    end
  end

  # Builds the value of the YM-User-Agent header sent with every API request.
  #
  # Mirrors yookassa.domain.common.user_agent.UserAgent from the Python SDK.
  class UserAgent
    PART_DELIMITER = ' '

    attr_accessor :os, :ruby, :sdk, :framework, :cms, :module_info

    def initialize
      @os = define_os
      @ruby = define_ruby
      @sdk = define_sdk
    end

    def set_framework(name, version)
      self.framework = YooKassa::Version.new(name, version)
      self
    end

    def set_cms(name, version)
      self.cms = YooKassa::Version.new(name, version)
      self
    end

    def set_module(name, version)
      self.module_info = YooKassa::Version.new(name, version)
      self
    end

    def get_header_string
      parts = [os.to_s, ruby.to_s]
      parts << framework.to_s if framework
      parts << cms.to_s if cms
      parts << module_info.to_s if module_info
      parts << sdk.to_s
      parts.join(PART_DELIMITER)
    end

    private

    def define_os
      name = os_name
      release = RbConfig::CONFIG['host_os'] || RUBY_PLATFORM
      YooKassa::Version.new(name, release)
    end

    def os_name
      host_os = RbConfig::CONFIG['host_os'].to_s
      case host_os
      when /mswin|mingw|cygwin/ then 'Windows'
      when /darwin/ then 'macOS'
      when /linux/ then 'Linux'
      when /bsd/ then 'BSD'
      else host_os
      end
    end

    def define_ruby
      YooKassa::Version.new('Ruby', RUBY_VERSION)
    end

    def define_sdk
      YooKassa::Version.new('YooKassa.Ruby', YooKassa::VERSION)
    end
  end
end
