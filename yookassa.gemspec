# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yookassa/version'

Gem::Specification.new do |spec|
  spec.name          = 'yookassa'
  spec.version       = YooKassa::VERSION
  spec.authors       = %w[YooMoney PSYCHONOISE]
  spec.email         = ['cms@yoomoney.ru']

  spec.summary       = 'YooKassa API Ruby Client Library'
  spec.description   = 'Ruby client for working with payments through the YooKassa API. ' \
                        'A faithful Ruby mirror of the official yookassa-sdk-python library.'
  spec.homepage      = 'https://github.com/PSYCHONOISE/yookassa-sdk-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # base64 moved from a default gem to a bundled gem in Ruby 3.4, and is no
  # longer implicitly on the load path under Bundler - declare it explicitly
  # so `require 'base64'` in lib/yookassa/client.rb keeps working on 3.4+/4.x.
  spec.add_dependency 'base64', '~> 0.2'

  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.60'
  spec.add_development_dependency 'webmock', '~> 3.19'
end
