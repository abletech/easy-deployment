# To load this capistrano configuration, require 'easy/deployment/logrotate' from deploy.rb
Capistrano::Configuration.instance(:must_exist).load do
  namespace :easy do
    namespace :logrotate do
      desc "Copies the application logrotate file into /etc/logrotate.d"
      task :setup, :except => { :no_release => true } do
        run "cp #{current_path}/config/deploy/#{stage}/logrotate.conf /etc/logrotate.d/#{application}.conf"
      end
    end
  end
end
