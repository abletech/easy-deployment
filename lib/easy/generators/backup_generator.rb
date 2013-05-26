require 'rails/generators'

module Easy
  class BackupGenerator < Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "templates") # Where templates are copied from

    include GeneratorHelpers

    desc %{Generates a backup config set to run nightly and upload to S3}

    def create_backup_files
      gem_group(:backup) do
        gem "whenever", :require => false
        # Rails 3.2.12 and lower of the Rails 3.2 release series requires mail ~> 2.4.X which neccesitates an older version of backup
        # We'll handle two cases: one for Rails 3.2.(0-12) and one for Rails 3.2.13 + Rails 4
        if "3.2" == "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}" && Rails::VERSION::STRING < "3.2.13"
          gem "backup", "~> 3.0.27", :require => false
          gem "fog",    "~> 1.4.0",  :require => false
          gem "mail",   "~> 2.4.0",  :require => false
        elsif Rails::VERSION::STRING >= "3.2.13" && [3,4].include?(Rails::VERSION::MAJOR)
          # Rails 3.2.13+ and Rails 4 only
          gem "backup",  "~> 3.1.3",               :require => false
          gem "fog",     "~> 1.9.0",               :require => false
          gem "net-ssh", ['>= 2.3.0', '<= 2.5.2'], :require => false
          gem "net-scp", ['>= 1.0.0', '<= 1.0.4'], :require => false
          gem "excon",   "~> 0.17.0",              :require => false
          gem "mail",    "~> 2.5.0",               :require => false
        else
          warn "Unsupported rails release detected. You'll need to manage your own dependencies for the backup gem"
          gem "backup", :require => false
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
