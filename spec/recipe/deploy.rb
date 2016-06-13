require 'capistrano'
module Capistrano
  module Fakerecipe
    def self.load_into(configuration)
      configuration.load do
        require 'easy/deployment/capistrano'
      end
    end
  end
end
