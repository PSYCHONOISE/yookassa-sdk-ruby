# frozen_string_literal: true

RSpec.describe YooKassa::SecurityHelper do
  describe '.ip_in_network?' do
    it 'returns true when the address is inside the given CIDR network' do
      expect(described_class.ip_in_network?('77.75.153.10', '77.75.153.0/25')).to be true
    end

    it 'returns false when the address is outside the given CIDR network' do
      expect(described_class.ip_in_network?('8.8.8.8', '77.75.153.0/25')).to be false
    end

    it 'treats a bare address network as a single-host match' do
      expect(described_class.ip_in_network?('77.75.156.11', '77.75.156.11')).to be true
      expect(described_class.ip_in_network?('77.75.156.12', '77.75.156.11')).to be false
    end
  end

  describe '#ip_trusted?' do
    subject(:helper) { described_class.new }

    it 'trusts an IPv4 address from a YooKassa network' do
      expect(helper.ip_trusted?('77.75.154.200')).to be true
    end

    it 'trusts any IPv6 address inside the published 2a02:5180::/32 range' do
      expect(helper.ip_trusted?('2a02:5180:0:1509::1')).to be true
      # Not one of the old, narrower /64s this gem used to hardcode - still
      # trusted because it falls inside the documented /32.
      expect(helper.ip_trusted?('2a02:5180:ffff:ffff::1')).to be true
    end

    it 'does not trust an IPv6 address outside the published /32 range' do
      expect(helper.ip_trusted?('2a02:5181::1')).to be false
    end

    it 'does not trust an address outside all YooKassa networks' do
      expect(helper.ip_trusted?('1.2.3.4')).to be false
    end
  end
end
