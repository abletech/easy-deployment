require 'rails/generators'
require 'optparse'

module Abletech
  class DeploymentGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    def application_name
      Rails.application.class.name.split("::").first.underscore # surely there's a better way than this
    end

    desc %{Generates standard able technology deployment script using capistrano}

    def create_deployment_files
      options = parse_options(ARGV)

      # If there was a deploy.rb initially, let the generator prompt to handle conflicts. Otherwise remove the default capistrano one, so we can override it silently with our template without being prompted      
      deploy_file_already_existed = File.exist?(File.join(destination_root, "config", "deploy.rb"))
      capify!
      remove_file("config/deploy.rb") unless deploy_file_already_existed # Removing this means we aren't prompted to overwrite if we only have the default capistrano deploy.rb
      # Write our default deploy.rb
      copy_file("deploy.rb.tt", "config/deploy.rb")

      # Generate all stages specified
      options[:stages] ||= %w(staging production)
      options[:stages].each do |stage|
        generate("abletech:stage", stage)
      end

      info = %{
Abletech Deployment Config now setup!

TODO:
  * Set the correct git repository in config/deploy.rb
}     
      options[:stages].each do |stage|
        info += "  * Set the ip address for staging in config/deploy/#{stage}.rb && the apache config in config/deploy/#{stage}/apache/#{application_name}"
      end
      puts info
      true
    end

    private

    # TODO: surely there's a better option parser built into thor, or the generators themselves?
    def parse_options(args)
      opts = {}
      OptionParser.new do |opt|
        opt.on("-s", "--stages" "Stages to generate") do |s|
          opts[:stages] = s.split(",") if s.present?
        end
      end.parse(args)
      opts
    end

  end
end
