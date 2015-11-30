require 'rails/generators'

module Easy
  class MaintenanceGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    desc %{Generates a maintenance config to allow you to put your application into maintenance mode}

    def create_maintenance_files
      gem 'turnout', '~> 2.2'

      template("maintenance.rb.tt",   "config/initializers/maintenance.rb")
      template("maintenance.html.tt", "public/maintenance.html")
      template("maintenance.json.tt", "public/maintenance.json")

      run("bundle install")

      say("Maintenance configuration generated", :green)
      say("  - TODO: edit config/initializers/maintenance.rb setting default_maintenance_page, default_reason and other configuration options", :green)
      say("  - TODO: edit public/maintenance.html to match site styles", :green)

      true
    end

  end
end
