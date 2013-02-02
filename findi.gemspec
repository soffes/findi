# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'findi/version'

Gem::Specification.new do |gem|
  gem.name          = 'findi'
  gem.version       = Findi::VERSION
  gem.authors       = ['Sam Soffes']
  gem.email         = ['sam@soff.es']
  gem.description   = "Find your iPhone through Apple's Find my iPhone API's."
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/soffes/findi'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency 'multi_json'
end
