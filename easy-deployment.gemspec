# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "easy/deployment/version"

Gem::Specification.new do |s|
  s.name        = "easy-deployment"
  s.version     = Easy::Deployment::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeremy Olliver", "Nigel Ramsay"]
  s.email       = ["jeremy.olliver@gmail.com", "nigel.ramsay@abletech.co.nz"]
  s.summary     = %q{Gem for encapsulating abletech's deployment practices}
  s.description = %q{Easy deployment: includes a generator, and capistrano configuration}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rails', '>= 3.0.0'
  s.add_runtime_dependency 'capistrano'
  s.add_runtime_dependency 'capistrano-ext'
  s.add_runtime_dependency 'capistrano_colors'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rcov'
end
