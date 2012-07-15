# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/niet' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  set :niet_process_count, 2

  namespace :niet do
    desc "Setup Niet"
    task :setup, roles: :job do
      run "mkdir -p #{shared_path}/niet"
    end

    desc "Starts the niet process monitor and its jobs"
    task :start, roles: :job do
      niet_process_count.times do |i|
        run "niet -p #{shared_path}/niet/jobs_worker_#{i}.pid -c #{current_path} bundle exec rake jobs:work RAILS_ENV=#{stage}"
      end
    end

    desc "Restarts the processes running under niet"
    task :restart, roles: :job do
      run "for job in #{shared_path}/niet/* ; do kill -TERM `cat $job`; done"
    end

    desc "Stops the processes running under niet and the niet process monitor"
    task :stop, roles: :job do
      run "for job in #{shared_path}/niet/* ; do kill -QUIT `cat $job`; done"
    end

    desc "Diplays the status of the niet process monitor"
    task :status, roles: :job do
      run "for job in #{shared_path}/niet/* ; do ps -fw `cat $job`; done"
    end
  end

  # niet hooks
  after  'deploy:setup',        'niet:setup'
  after  'deploy:start',        'niet:start'
  after  'deploy:restart',      'niet:restart'
end
