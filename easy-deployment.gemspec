# -*- encoding: utf-8 -*-
require File.expand_path('../lib/easy-deployment/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors          = ["Jeremy Olliver", "Nigel Ramsay", "Shevaun Coker"]
  gem.email             =  ["jeremy.olliver@gmail.com", "nigel.ramsay@abletech.co.nz", "shevaun.coker@abletech.co.nz"]
  gem.description    = %q{Easy deployment: includes a generator, and capistrano configuration}
  gem.summary       = %q{Gem for encapsulating abletech's deployment practices}
  gem.homepage     = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "easy-deployment"
  gem.require_paths = ["lib"]
  gem.version       = Easy::Deployment::VERSION
  

  gem.add_runtime_dependency 'rails', '>= 3.0.0'
  gem.add_runtime_dependency 'capistrano'
  gem.add_runtime_dependency 'capistrano-ext'
  gem.add_runtime_dependency 'capistrano_colors'

  gem.add_development_dependency 'bundler'
end
