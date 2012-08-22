# Define a capistrano task for creating nfs shared directories and symlinking them on deployment
# To load this capistrano configuraiton, require 'easy/deployment/nfs' from deploy.rb
#
# the default nfs_path is /opt/apps/nfs/shared, to change this value copy the line below
# set :nfs_path, "/var/apps/nfs/shared"
#
# nfs_shared_children consists of tmp/sessions by default; to add more children copy the line below
# set :nfs_shared_children, nfs_shared_children + %w(public/system)
Capistrano::Configuration.instance(:must_exist).load do
  set :nfs_path, "/opt/apps/nfs/shared"
  set :nfs_shared_children, %w(tmp/sessions)
    
  namespace :nfs do
    desc "Create folders under the nfs path to be shared between app servers"
    task :create_shared_dirs, :roles => :app, :only => {:primary => true} do
      nfs_shared_children.each do |child_path|
        run "mkdir -p #{nfs_path}/#{application}/#{child_path}; chmod g+w #{nfs_path}/#{application}/#{child_path}"
      end
    end

    desc "Symlink the shared folders to the nfs path on all app servers"
    task :symlink_shared_dirs, :roles => :app do
      nfs_shared_children.each do |child_path|
        run "ln -nfs #{nfs_path}/#{application}/#{child_path} #{release_path}/#{child_path}"
      end
    end
  end

  after  'deploy:setup',        'nfs:create_shared_dirs'
  after  'deploy:update_code',  'nfs:symlink_shared_dirs'
end
