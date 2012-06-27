# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/niet' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  namespace :niet do
    desc "Setup Niet"
    task :setup, roles: :job do
      run "mkdir -p #{shared_path}/niet"
    end

    desc "Starts the niet process monitor"
    task :start, roles: :job do
      2.times do |i|
        run "niet -p #{shared_path}/niet/jobs_worker_#{i}.pid -c #{current_path} bundle exec rake jobs:work RAILS_ENV=#{stage}"
      end
    end

    desc "Restarts the niet process monitor"
    task :restart, roles: :job do
      run "for job in #{shared_path}/niet/* ; do kill `cat $job`; done"
    end

    desc "Stops the niet process monitor"
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
