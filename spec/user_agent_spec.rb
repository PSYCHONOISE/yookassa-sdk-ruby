# frozen_string_literal: true

RSpec.describe YooKassa::UserAgent do
  describe '#get_header_string' do
    it 'always includes OS, Ruby and SDK fragments' do
      header = described_class.new.get_header_string

      expect(header).to match(%r{\A\S+/\S+ Ruby/#{Regexp.escape(RUBY_VERSION)} YooKassa\.Ruby/#{Regexp.escape(YooKassa::VERSION)}\z})
    end

    it 'includes framework, cms and module fragments when set, in order' do
      agent = described_class.new
      agent.set_framework('Django', '2.2.3')
      agent.set_cms('Wagtail', '2.6.2')
      agent.set_module('Y.CMS', '0.0.1')

      header = agent.get_header_string

      expect(header).to include('Django/2.2.3')
      expect(header).to include('Wagtail/2.6.2')
      expect(header).to include('Y.CMS/0.0.1')
      expect(header.index('Django/2.2.3')).to be < header.index('Wagtail/2.6.2')
      expect(header.index('Wagtail/2.6.2')).to be < header.index('Y.CMS/0.0.1')
      expect(header).to end_with("YooKassa.Ruby/#{YooKassa::VERSION}")
    end
  end
end

RSpec.describe YooKassa::Version do
  describe '#to_s' do
    it 'joins name and version with a slash' do
      expect(described_class.new('Django', '2.2.3').to_s).to eq('Django/2.2.3')
    end

    it 'replaces delimiter characters inside name/version with dots' do
      expect(described_class.new('My Framework', '1.2/3').to_s).to eq('My.Framework/1.2.3')
    end
  end
end
