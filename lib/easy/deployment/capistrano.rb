# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/capistrano' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do

  # ssh options
  set :use_sudo, false
  ssh_options[:forward_agent] = true # run `ssh-add ;` to ensure your identity file is added
  default_run_options[:pty] = true

  namespace :deploy do
    # By default, we deploy using passenger as an app server
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{File.join(current_path,'tmp','restart.txt')}"
    end

    desc "[internal] Copies the application configuration files for this environment"
    task :configure do
      if File.exists?("./config/deploy/#{stage}/database.yml")
        run "cp #{release_path}/config/deploy/#{stage}/database.yml #{release_path}/config/database.yml"
      else
        puts "Skipping copying of config/deploy/#{stage}/database.yml as the file is not present"
      end
    end

  end

  namespace :web do
    desc "Configure this site & Reload the apache configuration"
    task :configure do
      run "cp -f #{release_path}/config/deploy/#{stage}/apache/* /etc/apache2/sites-enabled/"
      run "sudo apache2ctl -k graceful"
    end
  end

  after "deploy:update_code", "deploy:configure"
end
