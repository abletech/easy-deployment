# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/niet' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  namespace :niet do
    desc "Starts the niet process monitor"
    task :start, roles: :job do
      2.times do
        run "niet -c #{current_path} bundle exec rake jobs:work RAILS_ENV=#{stage}"
      end
    end

    desc "Restarts the niet process monitor"
    task :restart, roles: :job do
      run "killall -u deploy niet"
    end

    desc "Stops the niet process monitor"
    task :stop, roles: :job do
      run "killall -u deploy -QUIT niet"
    end

    desc "Diplays the status of the niet process monitor"
    task :status, roles: :job do
      run "ps -fu deploy"
    end
  end

  # niet hooks
  after  'deploy:start',        'niet:start'
  after  'deploy:restart',      'niet:restart'
end
