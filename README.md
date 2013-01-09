# Easy::Deployment

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

This assumes your deploy user has access to run the apachectl command with sudo privileges

### Logrotate

Automatically configure logrotate for your application logfile:
If you have logrotate installed and /etc/logrotate.d is writable by your deploy user, simply

    require "easy/deployment/logrotate"

within your deploy.rb to have a logrotate config automatically written

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
