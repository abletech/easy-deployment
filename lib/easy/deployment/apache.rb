# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/apache' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  namespace :apache do
    desc "Configure this site & Reload the apache configuration"
    task :configure, :roles => :app, :except => { :no_release => true } do
      run "cp -f #{current_path}/config/deploy/#{stage}/apache/* /etc/apache2/sites-enabled/"
    end

    [:stop, :start, :restart].each do |action|
      desc "#{action.to_s.capitalize} Apache"
      task action, :roles => :web do
        run "sudo apache2ctl #{action.to_s}"
      end
    end
  end

  after 'apache:configure', 'apache:restart'
end
