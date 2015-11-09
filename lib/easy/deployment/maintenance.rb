# Define a capistrano task for putting the site into maintenance mode using
# turnout rack middleware.
# To load this capistrano configuration, require 'easy/deployment/maintenance' from deploy.rb
#
Capistrano::Configuration.instance(:must_exist).load do

  namespace :maintenance do
    desc "Put the application into maintenance mode"
    task :start, :roles => :app do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake maintenance:start"
    end

    desc "Take the application out of maintenance mode"
    task :end, :roles => :app do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake maintenance:end"
    end
  end

end
