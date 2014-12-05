# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_series/version'

Gem::Specification.new do |spec|
  spec.name          = "time_series"
  spec.version       = TimeSeries::VERSION
  spec.authors       = ["Martin Eismann"]
  spec.email         = ["martin.eismann@injixo.com"]
  spec.summary       = 'A one-dimensional timeseries with values at a regular interval'
  spec.description   = 'Comes with some basic features like average, sum. Combinable with other timeseries, e.g. to calculate a weighted average.'
  spec.homepage      = "https://github.com/meismann/time_series-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
end
