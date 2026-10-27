# frozen_string_literal: true

require 'ipaddr'

module YooKassa
  # Checks whether an IP address belongs to one of YooKassa's own networks,
  # so an incoming webhook notification can be verified as genuinely coming
  # from YooKassa (see docs/examples/01-configuration.md).
  #
  # The network list is kept in sync with the current list published at
  # https://yookassa.ru/developers/using-api/webhooks#ip, not with the
  # (narrower, outdated) IPv6 ranges hardcoded in the Python SDK.
  class SecurityHelper
    YOOKASSA_NETWORKS = [
      '185.71.76.0/27',
      '185.71.77.0/27',
      '77.75.153.0/25',
      '77.75.156.11',
      '77.75.156.35',
      '77.75.154.128/25',
      '2a02:5180::/32'
    ].freeze

    # @param ip [String]
    # @param network [String] a single address or a CIDR network
    # @return [Boolean]
    def self.ip_in_network?(ip, network)
      IPAddr.new(network).include?(IPAddr.new(ip))
    end

    # @param ip [String]
    # @return [Boolean] whether +ip+ belongs to one of YOOKASSA_NETWORKS
    def ip_trusted?(ip)
      YOOKASSA_NETWORKS.any? { |network| self.class.ip_in_network?(ip, network) }
    end
  end
end
