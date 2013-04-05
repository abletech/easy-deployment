# Changelog for easy-deployment

## 0.5.0 - 2013-04-05

Large rewrite of both templates, and generator code.

Major new feature is generation of backup config using the gems `whenever` and `backup`

Enhancements:

* Now fixed to capistrano 2.13.5 - dependencies on external capistrano-ext and capistrano_colors are removed.
* Added annotation task to write branch name, git revision, time of deploy, and user to the application root as version.txt
* Removed messy optparse code, and let Thor handle option parsing
* `deploy.rb` template now displays all feature modules, with some optional ones commented out
* `deploy.rb` template is now updated with current deployment practices (including newrelic and bugsnag services)
* Added generator to create backup configuration - for scheduling cron jobs to backup application data to S3

Bug Fixes:

* `deploy.rb` and `staging.rb` etc files are rendered correctly as templates, instead of copied over without rendering
* use `deploy:create_symlink` instead of deprecated `deploy:symlink`

## 0.4.4 - 2013-01-11

Bug Fixes:

* Bugfix for previous niet role definition, variable should be delayed being evaluated

## 0.4.3 - 2013-01-10

Enhancements:

* the server role for the niet tasks are now configurable via `set :niet_roles, [:job]`

## 0.4.2 - 2013-01-09

Enhancements:

* path to the binary apachectl command is now able to be configured via `set :apachectl_bin`
* Added documentation to README.md for several of the optional features

## 0.4.1 - 2012-12-10

Bug Fixes:

* raise exception if `cap niet:start` is run without `cap niet:setup` being run first

## 0.4.0 - 2012-11-19

Enhancements:

* include capistrano_colors by default
* apache:configure task now copies a folder stage/apache/* if present falling back to previous state/apache.conf
* added `easy/deployment/performance` optional require to track the times of deployments

## 0.3.3 - 2012-10-16

Bug Fixes

* `deploy:reference` should use the rails_env, not the stage

## 0.3.0 - 2012-09-04

Enhancements:

* Add `apache:configure_and_reload` capistrano task, which will configure the site, test the configuration & gracefully reload the Apache configuration

## 0.2.2 - 2012-08-27

Enhancements:

* Add `apache:configtest` capistrano task

Bug Fixes:

* Spelling corrections
