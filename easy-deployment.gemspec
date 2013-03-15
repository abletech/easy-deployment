# -*- encoding: utf-8 -*-
require File.expand_path('../lib/easy-deployment/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeremy Olliver", "Nigel Ramsay", "Shevaun Coker", "Cameron Fowler"]
  gem.email         =  ["jeremy.olliver@abletech.co.nz", "nigel.ramsay@abletech.co.nz", "shevaun.coker@abletech.co.nz", "cameron.fowler@abletech.co.nz"]
  gem.description   = %q{Easy deployment: includes a generator, and capistrano configuration}
  gem.summary       = %q{Gem for encapsulating Abletech's deployment practices}
  gem.homepage      = "https://github.com/AbleTech/easy-deployment"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "easy-deployment"
  gem.require_paths = ["lib"]
  gem.version       = Easy::Deployment::VERSION

  gem.add_runtime_dependency 'rails', '>= 3.0.0'
  gem.add_runtime_dependency 'capistrano', '~> 2.13.5'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec', '~> 2.0'
end
