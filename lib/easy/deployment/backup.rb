# To load this capistrano configuration, require 'easy/deployment/backup' from deploy.rb
Capistrano::Configuration.instance(:must_exist).load do
  namespace :easy do
    namespace :backup do
      desc "Creates the shared folders that backup requires"
      task :setup, :except => { :no_release => true } do
        run "mkdir -p #{shared_path}/backup/data"
      end
    end
  end

  after 'deploy:setup', 'easy:backup:setup'
end
