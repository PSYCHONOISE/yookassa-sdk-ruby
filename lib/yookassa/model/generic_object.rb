# frozen_string_literal: true

module YooKassa
  # A fully dynamic BaseObject: every key passed to .new becomes an attribute.
  #
  # Used to wrap nested Hashes found inside generic, pass-through models
  # (payment method data, confirmation, payout destination, ...) so they can
  # be accessed with dotted attribute syntax (`card.last4`) instead of raw
  # Hash indexing, without having to hand-write a class for every documented
  # API variant.
  class GenericObject < BaseObject
  end
end
