# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/capistrano' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do

  # ssh options
  set :use_sudo, false
  ssh_options[:forward_agent] = true # run `ssh-add ;` to ensure your identity file is added
  default_run_options[:pty] = true

  namespace :deploy do
    desc "Initial deploy including database creation and apache2 config setup"
    task :inital do
      set :migrate_target, :latest
      update # updates_code and creates symlink
      create_db
      migrate
      top.namespace(:logrotate) {setup}
      top.namespace(:apache)    {configure}
      restart
    end

    desc "Create the database"
    task :create_db, :roles => :db, :only => {:primary => true} do
      migrate_target = fetch(:migrate_target, :latest)

      directory = case migrate_target.to_sym
                  when :current then current_path
                  when :latest  then latest_release
                  else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                  end
      run "cd #{directory}; RAILS_ENV=#{stage} bundle exec rake db:create"
    end

    desc "Load reference data"
    task :reference_data, :roles => :db, :only => { :primary => true } do
      migrate_target = fetch(:migrate_target, :latest)

      directory = case migrate_target.to_sym
                  when :current then current_path
                  when :latest  then latest_release
                  else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                  end

      run "cd #{directory} && RAILS_ENV=#{stage} bundle exec rake reference:load"
    end

    # By default, we deploy using passenger as an app server
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end

    desc "[internal] Copies the application configuration files for this environment"
    task :configure do
      if File.exists?("./config/deploy/#{stage}/database.yml")
        run "cp #{release_path}/config/deploy/#{stage}/database.yml #{release_path}/config/database.yml"
      else
        puts "Skipping copying of config/deploy/#{stage}/database.yml as the file is not present"
      end
    end

    desc "Allow deployment of a branch, commit or tag"
    task :set_branch do
      set :branch, ENV['tag'] || 'master'
    end
  end

  namespace :web do
    desc "Deprecated - use apache:configure instead"
    task :configure, :roles => :app, :except => { :no_release => true } do
      puts "Deprecated - use apache:configure instead"
    end
  end


  before 'deploy:update_code',  'deploy:set_branch' # allow specification of branch, tag or commit on the command line
end
