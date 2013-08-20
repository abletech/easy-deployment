# Easy::Deployment

[![Gem Version](https://badge.fury.io/rb/easy-deployment.png)](http://badge.fury.io/rb/easy-deployment)
[![Dependency Status](https://gemnasium.com/AbleTech/easy-deployment.png)](https://gemnasium.com/AbleTech/easy-deployment)
[![Code Climate](https://codeclimate.com/github/AbleTech/easy-deployment.png)](https://codeclimate.com/github/AbleTech/easy-deployment)

This gem is for encapsulating Abletech's common deployment patterns using capistrano.

## Installation

Add this line to your application's Gemfile:

    gem 'easy-deployment', :git => "git@github.com:AbleTech/easy-deployment.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy-deployment

## Usage

Run:

    $ rails g easy:deployment

The templated configuration files leave several lines blank for you to fill in with TODO placeholders, so it's a good idea to run `rake notes:todo` after installation to see if you've missed any.
Replace any missing configuration lines, and don't forget to remove the TODO text/comments

## Integration

### Apache

Automatically setup an Apache V-Host, and reload apache2:

If you are running under Apache (with passenger or otherwise), and the sites-available
directory is writable by your deploy user. easy-deployment can automatically write a v-host config
to that directory and perform a soft reload (graceful) of apache2 to automatically configure your site.

Add to deploy.rb

    require "easy/deployment/apache"

Customise the vhost file within `config/deploy/<stage>/apache/<app>.conf`
If necessary, you can set the path to the apache2ctl binary via:

    set :apachectl_bin, "/usr/sbin/apachectl"

This assumes your deploy user has access to run the apachectl command with sudo privileges. As a recommended security practice, your deploy user should not have general sudo access, instead configure limited sudo access for specific commands only, declaring the full binary path. Having passwordless sudo *only* for these limited commands can make this smoother, but is not a requirement - capistrano will prompt for sudo password if that is required.

    # Example sudoers file entries to grant deploy user passwordless sudo privileges to only these commands
    deploy ALL=(ALL) NOPASSWD:/usr/sbin/apachectl graceful
    deploy ALL=(ALL) NOPASSWD:/usr/sbin/apachectl configtest

### Logrotate

Automatically configure logrotate for your application logfile:
If you have logrotate installed and /etc/logrotate.d is writable by your deploy user, simply

    require "easy/deployment/logrotate"

within your deploy.rb to have a logrotate config automatically written

### Backup

This includes a generator to create a backup configuration (generator may be disabled when running easy:deployment by passing `--disable-backup`, or run by itself as `rails generate easy:backup`)

This will generate:

    config/backup.rb
    config/schedule.rb
    config/s3.yml

The created backup configuration will be scheduled on deploy to run nightly via the whenever integration below, and with a backup configuration at `config/backup.rb`
The default setup is to backup the capistrano system folder, the configured database, to store the backup in S3, and notify of failures via email.
All these settings are configurable, to read more see the documentation for the backup gem https://github.com/meskyanichi/backup and setup your configuration to suit yourself.

### Whenever

If you use the whenever gem to manage application crontabs, automatically include the capistrano
hooks to run whenever each deploy via:

    require "easy/deployment/whenever"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Abletech
http://www.abletech.co.nz/
