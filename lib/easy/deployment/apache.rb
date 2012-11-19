# Define some defaults for Capistrano deploys.
# To load this Capistrano configuration, require 'easy/deployment/apache' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end

  namespace :apache do
    desc "Configure this site, test the configuration & gracefully reload the Apache configuration"
    task :configure_and_reload, :roles => :web, :except => { :no_release => true } do
      configure
      configtest
      graceful
    end

    desc "Configure this site (with files from config/deploy/apache/* or config/deploy/apache.conf)"
    task :configure, :roles => :web, :except => { :no_release => true } do
      apache_dir_path = "#{current_path}/config/deploy/#{stage}/apache"
      if remote_file_exists?(apache_dir_path) # multiple apache files
        files = capture("for f in #{apache_dir_path}/*; do echo $f; done").split("\r\n")
        files.each do |file|
          file_name = file.split(/\/([^\/]+)$/)[1]
          run "cp -f #{file} /etc/apache2/sites-available/#{file_name}"
          run "ln -fs /etc/apache2/sites-available/#{file_name} /etc/apache2/sites-enabled/#{file_name}"
        end
      else # single apache file (to be deprecated)
        run "cp -f #{current_path}/config/deploy/#{stage}/apache.conf /etc/apache2/sites-available/#{application}"
        run "ln -fs /etc/apache2/sites-available/#{application} /etc/apache2/sites-enabled/#{application}"
      end

      configure_mods
    end

    desc "Configure apache mods (currently only supports passenger.conf)"
    task :configure_mods, :roles => :web, :except => { :no_release => true } do
      passenger_conf = "#{current_path}/config/deploy/#{stage}/passenger.conf"

      if remote_file_exists?(passenger_conf)
        run "cp -f #{passenger_conf} /etc/apache2/mods-available/passenger.conf"
        run "ln -fs /etc/apache2/mods-available/passenger.conf /etc/apache2/mods-enabled/passenger.conf"
      else
        puts "Passenger.conf not found, not configuring any apache mods"
      end
    end

    [:stop, :start, :restart, :graceful, :configtest].each do |action|
      desc (action == :graceful ? "Restart Apache gracefully" : "#{action.to_s.capitalize} Apache")
      task action, :roles => :web do
        run "sudo apache2ctl #{action.to_s}"
      end
    end
  end

  before 'deploy:start', 'apache:configure_and_reload'
end
