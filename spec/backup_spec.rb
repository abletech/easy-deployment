require 'spec_helper'
require 'capistrano'

describe Easy::Deployment, "Easy Deployment backup tasks" do

  before do
    @config = Capistrano::Configuration.new
    @config.extend(Capistrano::Spec::ConfigurationExtension)
  end

  it "should create a backup directory" do

    @config.load do
      require 'easy/deployment/backup'

      set :shared_path, 'rspec'
    end

    @config.find_and_execute_task('easy:backup:setup')

    @config.should have_run "mkdir -p rspec/backup/data"
  end
end
