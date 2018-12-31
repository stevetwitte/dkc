require "thor"
require "dkc/constants"
require "dkc/config"

module Dkc
  class Main < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "up", "Provision containers"
    def up
      puts "Bringing Containers Up..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customUp") == nil
        run("docker-compose up -d")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customUp") != nil
        run(Dkc::Config.instance.getValue("customUp"))
      end

    rescue StandardError => e
      puts e.message
      return false
    end

    desc "bash", "Start Bash on main container"
    def bash
      puts "Starting Bash..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      main_container = Dkc::Config.instance.getValue("mainContainer")

      if main_container.class != String || main_container.length <= 0
        raise StandardError.new("ERROR: No mainContainer value in #{CONFIG_FILE_NAME}")
      end

      run("docker-compose exec #{main_container} bash")

    rescue StandardError => e
      puts e.message
      return false
    end
  end
end
