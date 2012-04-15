require 'rails/generators'

module Easy
  class LogrotateGenerator < Rails::Generators::NamedBase
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    desc %{Generate a new logrotate.conf file for the given environment name\ne.g. rails g easy:logrotate workshop}

    def generate_stage
      # directory("stage", "config/#{name}")

      # Ensure we have a config/deploy/<env-name>/logrotate.rb
      # dest = "config/deploy/#{name}/logrotate.conf"
      # in_root do
      #   unless File.exist?(dest)
      #     run("cp config/environments/production.rb #{dest}")
      #   end
      # end
    end
  end
end
