# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/niet' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  set :niet_process_count, 2
  set :niet_roles, [:job]

  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end

  namespace :niet do
    desc "Setup Niet"
    task :setup, roles: lambda { niet_roles } do
      run "mkdir -p #{shared_path}/niet"
    end

    desc "Starts the niet process monitor and its jobs"
    task :start, roles: lambda { niet_roles } do
      if remote_file_exists?("#{shared_path}/niet")
        niet_process_count.times do |i|
          run "niet -p #{shared_path}/niet/jobs_worker_#{i}.pid -c #{current_path} bundle exec rake jobs:work RAILS_ENV=#{stage}"
        end
      else
        raise StandardError, "shared niet directory doesn't exist! Please run `cap #{stage} niet:setup` first"
      end
    end

    desc "Restarts the processes running under niet"
    task :restart, roles: lambda { niet_roles } do
      if remote_file_exists?("#{shared_path}/niet")
        run "for job in #{shared_path}/niet/* ; do kill -TERM `cat $job`; done"
      else
        raise StandardError, "shared niet directory doesn't exist! Please run `cap #{stage} niet:setup` first"
      end
    end

    desc "Stops the processes running under niet and the niet process monitor"
    task :stop, roles: lambda { niet_roles } do
      run "for job in #{shared_path}/niet/* ; do kill -QUIT `cat $job`; done"
    end

    desc "Displays the status of the niet process monitor"
    task :status, roles: lambda { niet_roles } do
      run "for job in #{shared_path}/niet/* ; do ps -fw `cat $job`; done"
    end
  end

  # niet hooks
  after  'deploy:setup',        'niet:setup'
  after  'deploy:start',        'niet:start'
  after  'deploy:restart',      'niet:restart'
end
