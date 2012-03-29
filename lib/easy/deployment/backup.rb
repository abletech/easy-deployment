# To load this capistrano configuration, require 'easy/deployment/backup' from deploy.rb
Capistrano::Configuration.instance(:must_exist).load do
  namespace :easy do
    namespace :backup do
      desc "Creates the shared folders that backup requires"
      task :setup, :except => { :no_release => true } do
        run "mkdir -p #{shared_path}/backup/data"
      end

      desc "Adds a symbolic link from the s3.yml file in the shared/backup into the current/config folder"
      task :symlink_s3_config do
        run "ln -sf #{shared_path}/backup/s3.yml #{current_path}/config/s3.yml"
      end
    end
  end

  after 'deploy:setup', 'easy:backup:setup'
  after 'deploy:symlink', 'easy:backup:symlink_s3_config'
end
