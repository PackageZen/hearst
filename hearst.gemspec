# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hearst/version'

Gem::Specification.new do |spec|
  spec.name          = "hearst"
  spec.version       = Hearst::VERSION
  spec.authors       = ["Daniel Mackey"]
  spec.email         = ["mackey@packagezen.com"]

  spec.summary       = "Provides a declarative pattern for publishing/subscribing to RabbitMQ"
  spec.description   = "A simple ruby library to easily handle publishing events to RabbitMQ, as well as a pattern for declaring and responsing to subscribed RabbitMQ messages"
  spec.homepage      = "https://github.com/packagezen/hearst"
  spec.license       = ["MIT"]

  spec.files         = Dir["**/*"].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files    = Dir["spec/**/*"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency "bunny", "~> 2.2"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
