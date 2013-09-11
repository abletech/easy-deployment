# Define some defaults for capistrano deploys.
# To load this capistrano configuraiton, require 'easy/deployment/capistrano' from deploy.rb

Capistrano::Configuration.instance(:must_exist).load do

  # color the string
  def red(str)
    "\e[31m#{str}\e[0m"
  end

  # Get the name of the current local branch
  def current_git_branch
    current_branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
    puts red("Warning: Redundant use of 'tag'. Your current branch is deployed by default") if ENV['tag'] == current_branch
    branch_to_deploy = ENV['tag'] || current_branch
    puts "Deploying branch #{red branch_to_deploy}"
    branch_to_deploy
  end

  set :branch, current_git_branch

  # ssh options
  set :use_sudo, false
  ssh_options[:forward_agent] = true # run `ssh-add ;` to ensure your identity file is added
  default_run_options[:pty] = true

  namespace :deploy do
    desc "Initial deploy including database creation and triggers hooks on start. Require 'easy/deployment/apache' to configure and restart apache as part of this task, and require 'easy/deployment/logrotate' to setup logrotate as part of this task"
    task :initial do
      set :migrate_target, :latest
      update # updates_code and creates symlink
      create_db
      migrate
      start # doesn't do anything but triggers associated hooks
    end

    desc "Create the database"
    task :create_db, :roles => :db, :only => {:primary => true} do
      migrate_target = fetch(:migrate_target, :latest)

      directory = case migrate_target.to_sym
                  when :current then current_path
                  when :latest  then latest_release
                  else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                  end
      run "cd #{directory}; RAILS_ENV=#{rails_env || stage} bundle exec rake db:create"
    end

    # By default, we deploy using passenger as an app server
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end

    desc "[internal] Copies the application configuration files for this environment"
    task :configure do
      if File.exists?("./config/deploy/#{stage}/database.yml")
        run "cp #{release_path}/config/deploy/#{stage}/database.yml #{release_path}/config/database.yml"
      else
        puts "Skipping copying of config/deploy/#{stage}/database.yml as the file is not present"
      end
    end

    desc "[internal] Check ssh-key is added. ssh key forwarding deployments will fail without it"
    # To disable this check set the variable `set :ignore_ssh_keys, true`
    task :preflight_environment_check do
      if fetch(:disable_agent_check, false) || !ssh_options[:forward_agent]
        return true # Don't run the check if not using ssh agent forwarding
      end
      keys, status = run_local("ssh-add -L")
      if fetch(:ignore_ssh_keys, false) || status != 0 || !(any_keys_registered = keys.chomp.split("\n").select {|line| line =~ /^ssh\-/ }.size > 0)
        cmd_to_run = case RUBY_PLATFORM
        when /darwin/
          "ssh-add -K"
        else
          "ssh-add"
        end
        Capistrano::CLI.ui.say("<%= color('Error, no ssh-keys registered to be forwarded', :red) %>")
        Capistrano::CLI.ui.say("<%= color('Run the following command to register your ssh-key then try again:', :red) %> #{cmd_to_run}")
        Capistrano::CLI.ui.say("If you do not use ssh-agent-forwarding, put `set :disable_agent_check, true` in deploy.rb to disable this check")
        exit(1)
      else
        Capistrano::CLI.ui.say("<%= color('ssh-keys are good to go captain!', :cyan) %>") if ENV['DEBUG']
      end
    end
  end

  namespace :tail do
    desc "Stream live log output. USAGE tail:live_logs"
    task :live_logs, :roles => :app do
      stream_output_from_command("tail -f #{shared_path}/log/#{rails_env}.log", true)
    end

    desc "Show recent log output. USAGE tail:recent_logs [lines=n] (defaults to 100)"
    task :recent_logs, :roles => :app do
      lines = ENV['lines'] || 100
      stream_output_from_command("tail -n#{lines} #{shared_path}/log/#{rails_env}.log")
    end
  end

  desc "[internal] Tag the release by creating or moving a remote branch named after the current environment"
  task :tag_release do
    if system("git branch -r | grep 'origin/releases/#{stage}'")
      system "git push origin :releases/#{stage}"
    end
    system "git push origin #{branch}:releases/#{stage}"
  end

  desc "[internal] Annotate release into version.txt"
  task :annotate_release do
    git_revision = `git rev-parse #{branch} 2> /dev/null`.strip
    version_info = "Branch/Tag: #{branch}\\nRevision: #{git_revision}\\nDeployed To: #{stage}\\n\\nDeployed At: #{Time.now}\\nBy: #{`whoami`.chomp}\\n"
    run %Q(printf "#{version_info}" > #{release_path}/version.txt)
  end

  before "deploy:update", "deploy:preflight_environment_check"
  after "deploy:update", "tag_release"
  after "deploy:update", "annotate_release"

  def run_local(cmd, verbose = false)
    result = `#{cmd}`
    puts(result) if verbose
    return [result, $?.exitstatus]
  end

  # Helper function to stream output colorized by host
  def stream_output_from_command(cmd, continuous = false)
    trap("INT") { puts 'Output cancelled'; exit 0; }
    Capistrano::CLI.ui.say("<%= color('Streaming output Ctrl+c to cancel', :blue) %>") if continuous

    run(cmd) do |channel, stream, data|
      puts  # for an extra line break before the host name
      Capistrano::CLI.ui.say("<%= color('#{channel[:host]}', :cyan) %>: #{data}")
      # puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end

end
