# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomtom_webfleet_connect/version'

Gem::Specification.new do |gem|
  gem.name          = "tomtom_webfleet_connect"
  gem.version       = TomtomWebfleetConnect::VERSION
  gem.authors       = ["Maxime Lenne"]
  gem.email         = ["maxime.lenne@gmail.com"]
  gem.description   = %q{Ruby gem for easily integrate tomtom webfleet connect}
  gem.summary       = %q{Ruby wrapper tomtom webflet connect for ruby application}
  gem.homepage      = "https://github.com/maxime-lenne/tomtom_webfleet_connect"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
