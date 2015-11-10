require 'rails/generators'
require "easy/generators/generator_helpers"

module Easy
  class DeploymentGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    include GeneratorHelpers

    desc %{Generates standard able technology deployment script using capistrano}

    class_option :stages,            :type => :array,   :default => ['staging', 'production'], :aliases => :s
    class_option :disable_backup,    :type => :boolean, :default => false
    class_option :disable_bugsnag,   :type => :boolean, :default => false
    class_option :disable_newrelic,  :type => :boolean, :default => false
    class_option :no_asset_pipeline, :type => :boolean, :default => false

    def create_deployment_files
      template("deploy.rb.tt", "config/deploy.rb") # Generate deploy.rb first to use ours not capistrano's deploy.rb
      copy_file("Capfile") unless options[:no_asset_pipeline] # Do this first
      capify!

      # Generate all stages specified
      options[:stages].each do |stage|
        generate("easy:stage", stage)
      end

      install_message = %Q(
Easy Deployment Config now setup!

TODO:
  * Set the correct git repository in config/deploy.rb
  #{"* Edit Capfile and enable asset pipeline compilation if you are using it (uncomment load 'deploy/assets')\n" if options[:no_asset_pipeline]})

      say(install_message, :green)
      options[:stages].each do |stage|
        say("  * Set the ip address for staging in config/deploy/#{stage}.rb && the apache config in config/deploy/#{stage}/apache.conf", :green)
      end

      add_optional_operational_gems

      true
    end

    private

    def add_optional_operational_gems
      needs_bundle = false

      unless options[:disable_newrelic]
        say_status(:configure, "New Relic gem")
        gem("newrelic_rpm", ">= 3.5.3.25")
        needs_bundle = true
      end
      unless options[:disable_bugsnag]
        say_status(:configure, "bugsnag")
        gem("bugsnag")
        needs_bundle = true
      end

      unless options[:disable_backup]
        generate("easy:backup")
        needs_bundle = false # because easy:backup runs bundle install
      end

      bundle_command(:install) if needs_bundle
    end

  end
end
