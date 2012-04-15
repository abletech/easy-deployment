require 'rails/generators'

module Easy
  class StageGenerator < Rails::Generators::NamedBase
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    desc %{Generate a new deployment script for the given environment name\ne.g. rails g easy:stage workshop}

    def generate_stage
      directory("stage", "config/deploy/#{name}")
      copy_file("stage.rb.tt", "config/deploy/#{name}.rb")

      # Ensure we have a config/environments/<env-name>.rb
      dest = "config/environments/#{name}.rb"
      in_root do
        unless File.exist?(dest)
          run("cp config/environments/production.rb #{dest}")
        end
      end
    end

  end
end
