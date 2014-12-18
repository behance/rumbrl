# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rumbrl/version'

Gem::Specification.new do |spec|
  spec.name          = 'rumbrl'
  spec.version       = Rumbrl::VERSION
  spec.authors       = ['chr0n1x']
  spec.email         = ['heilong24@gmail.com']
  spec.description   = 'Really_dUMB_Ruby_Logger'
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rubocop', '~> 0.24'
  spec.add_development_dependency 'shoulda-matchers', '~> 2.7'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'gem-release'
end
