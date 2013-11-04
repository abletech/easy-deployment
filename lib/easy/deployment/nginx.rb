# Define some defaults for Capistrano deploys.
# To load this Capistrano configuration, require 'easy/deployment/nginx' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do
  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end

  set :nginx_bin, "/etc/init.d/nginx"
  set :nginx_dir, "/etc/nginx"

  namespace :nginx do
    desc "Configure this site, test the configuration & gracefully reload the Nginx configuration"
    task :configure_and_reload, :roles => :web, :except => { :no_release => true } do
      configure
      configtest
      reload
    end

    desc "Configure this site with config/deploy/nginx.conf)"
    task :configure, :roles => :web, :except => { :no_release => true } do
      run "cp -f #{current_path}/config/deploy/#{stage}/nginx.conf #{nginx_dir}/sites-available/#{application}"
      run "ln -fs #{nginx_dir}/sites-available/#{application} #{nginx_dir}/sites-enabled/#{application}"
    end

    [:stop, :start, :restart, :reload, :configtest].each do |action|
      desc "#{action.to_s.capitalize} Nginx"
      task action, :roles => :web do
        run "sudo #{nginx_bin} #{action.to_s}"
      end
    end
  end

  before 'deploy:start', 'nginx:configure_and_reload'
end
