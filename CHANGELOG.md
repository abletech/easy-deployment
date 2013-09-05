# Changelog for easy-deployment

## 0.5.3 (2013-09-05)

Bugfixes:

* `bundle_without` was previously set incorrectly in the deploy.rb template, this has been removed from the template. Recommended to remove from your deploy.rb, but low impact.

Featues:

* Added support for multiple platform apache/passenger in the apache tasks. (apache path can now be set)
* Logrotate configuration is now run on each deploy. Previously was only hooked on deploy:start which may not always be run for passenger setups.
* Removed deploy.rb template comments re 'rvm-capistrano' deploying, as we don't primarily deploy off rvm.
* Links to further documentation on the github wiki added to the deploy.rb file

## 0.5.2 (2013-08-20)

Bugfixes:

* Fix misplaced comments in the default `apache.conf` template that this library generates

New Features:

* Added support for rails asset caching in apache.conf template (provided expires module is enabled)
* Added links to further documentation on passenger VirtualHost patterns to the github wiki

## 0.5.1 (2013-05-27)

Bugfixes:

* Backup gem requirements for rails 3.2.13 fixed: should be the same as the rails 4 ones, not earlier rails 3 releases
* Fixed `cap deploy:initial` for cases where the deploy stage name didn't match the rails_env name
* Fixed backup template not pulling the environment specific hash out of database config

New Features:

* Tail the rails log of your remote servers (either streaming live or the last N lines) `cap tail:live_logs` + `cap tail:recent logs`
* Load the capistrano rails assetpipeline support by default (can be skipped via generator option)
* Apache/passenger config template now sets `PassengerMinInstances` and provides some disabled example tuning options
* Specified license in the gemspec

## 0.5.0 (2013-04-05)

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

## 0.4.4 (2013-01-11)

Bug Fixes:

* Bugfix for previous niet role definition, variable should be delayed being evaluated

## 0.4.3 (2013-01-10)

Enhancements:

* the server role for the niet tasks are now configurable via `set :niet_roles, [:job]`

## 0.4.2 (2013-01-09)

Enhancements:

* path to the binary apachectl command is now able to be configured via `set :apachectl_bin`
* Added documentation to README.md for several of the optional features

## 0.4.1 (2012-12-10)

Bug Fixes:

* raise exception if `cap niet:start` is run without `cap niet:setup` being run first

## 0.4.0 (2012-11-19)

Enhancements:

* include capistrano_colors by default
* apache:configure task now copies a folder stage/apache/* if present falling back to previous state/apache.conf
* added `easy/deployment/performance` optional require to track the times of deployments

## 0.3.3 (2012-10-16)

Bug Fixes

* `deploy:reference` should use the rails_env, not the stage

## 0.3.0 (2012-09-04)

Enhancements:

* Add `apache:configure_and_reload` capistrano task, which will configure the site, test the configuration & gracefully reload the Apache configuration

## 0.2.2 (2012-08-27)

Enhancements:

* Add `apache:configtest` capistrano task

Bug Fixes:

* Spelling corrections
