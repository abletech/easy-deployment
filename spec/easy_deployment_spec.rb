require 'spec_helper.rb'

describe Easy::Deployment do
  it "has a version number" do
    Easy::Deployment::VERSION.should be_present
  end
end
