require 'json'
require "singleton"
require "dkc/constants"

module Dkc
  class Config
    include Singleton

    def load
      begin
        config_file = File.read(CONFIG_FILE_NAME)
        parsed_data = JSON.parse(config_file)

        if parsed_data.class != Hash
          raise StandardError.new("ERROR: JSON Failed to parse in #{CONFIG_FILE_NAME}")
        end

        @configuration = parsed_data

      rescue Errno::ENOENT
        return false
      rescue StandardError => e
        puts e.message
        return false
      end

      return true
    end

    def getValue(key)
      @configuration[key]
    end
  end
end
