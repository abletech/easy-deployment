require 'spec_helper'
require 'capistrano'
require File.expand_path('../recipe/deploy', __FILE__)

describe Easy::Deployment, "loaded into a configuration" do

  before do
    @config = Capistrano::Configuration.new
  end

  it "should set branch using tag environment variable" do
    ENV['tag'] = 'hello tag'

    Capistrano::Fakerecipe.load_into(@config)

    @config.fetch(:branch).should eq('hello tag')

    expect do
      should have_put('Deploying branch hello tag')
    end
  end
end
