require 'rails/generators'

module Easy
  class BackupGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    include GeneratorHelpers

    RAILS_4_GEMS = {
      "backup" => "~> 3.0.27",
      "fog" => "~> 1.4.0",
      "mail" => "~> 2.4.0"
    }

    RAILS_4_GEMS = {
      "backup"  => "~> 3.1.3",
      "fog"     => "~> 1.9.0",
      "net-ssh" => "<= 2.5.2", # Greater than >= 2.3.0 as well, though we can't express that
      "net-scp" => "<= 1.0.4", # Greater than 1.0.0
      "excon"   => "~> 0.17.0",
      "mail"    => "~> 2.5.0"
    }

    desc %{Generates a backup config set to run nightly and upload to S3}

    def create_backup_files
      gem_requirements = case Rails::VERSION::MAJOR
      when 3
        RAILS_4_GEMS
      when 4
        RAILS_4_GEMS
      else
        raise "Unsupported rails version - only rails 3 and rails 4 are supported"
      end

      gem_group(:backup) do
        gem "whenever", :require => false
        gem_requirements.each do |gem_name, version_constraints|
          gem gem_name, version_constraints, :require => false
        end
      end

      template("backup.rb.tt", "config/backup.rb")
      template("schedule.rb.tt", "config/schedule.rb")
      copy_file("s3.yml", "config/s3.yml")

      run("bundle install")

      say("Backup configuration generated", :green)
      say("  - TODO: edit config/backup.rb setting notification addresses and other configuration options", :green)
      say("  - TODO: ensure your S3 keys are set in config/s3.yml", :green)

      true
    end

  end
end
