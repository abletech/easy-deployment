require 'rails/generators'

module Easy
  class BackupGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    include GeneratorHelpers

    desc %{Generates a backup config set to run nightly and upload to S3}

    def create_backup_files
      gem_group(:backup) do
        gem "backup", "~> 3.1.3", :require => false
        gem "fog",    "~> 1.9.0", :require => false
        gem "whenever",           :require => false
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
