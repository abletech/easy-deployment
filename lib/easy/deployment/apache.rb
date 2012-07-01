# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/apache' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  namespace :apache do
    desc "Configure this site & Reload the apache configuration"
    task :configure, :roles => :app, :except => { :no_release => true } do
      run "cp -f #{current_path}/config/deploy/#{stage}/apache.conf /etc/apache2/sites-available/#{application}"
      run "ln -fs /etc/apache2/sites-available/#{application} /etc/apache2/sites-enabled/#{application}"
    end

    [:stop, :start, :restart].each do |action|
      desc "#{action.to_s.capitalize} Apache"
      task action, :roles => :web do
        run "sudo apache2ctl #{action.to_s}"
      end
    end
  end

  before 'deploy:start', 'apache:configure'
  after 'apache:configure', 'apache:restart'
end
