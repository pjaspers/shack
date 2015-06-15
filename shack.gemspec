# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shack/version'

Gem::Specification.new do |spec|
  spec.name          = "shack"
  spec.version       = Shack::VERSION
  spec.authors       = ["pjaspers"]
  spec.email         = ["piet@pjaspers.com"]
  spec.summary       = %q{Sha + Rack = Shack }
  spec.description   = %q{Rack middleware to expose a potential sha}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.cert_chain  = ['certs/pjaspers.pem']
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.add_development_dependency "bundler", "~> 1.7"
end
