# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsync/version'

Gem::Specification.new do |spec|
  spec.name          = "rsync"
  spec.version       = Rsync::VERSION
  spec.authors       = ["Joshua Bussdieker"]
  spec.email         = ["jbussdieker@gmail.com"]
  spec.summary       = %q{Ruby/Rsync is a Ruby library that can synchronize files between remote hosts by wrapping a call to the rsync binary.}
  spec.homepage      = "http://github.com/jbussdieker/ruby-rsync"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
