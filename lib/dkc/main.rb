require "thor"
require "dkc/constants"
require "dkc/config"

module Dkc
  class Main < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "init", "Create a new .dkc.config"
    def init
      config_file = File.new(CONFIG_FILE_NAME, "w+")
      config_file.write(CONFIG_FILE_EXAMPLE)
      config_file.close
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
      exit false
    end

    desc "down", "Stopping and removing containers"
    def down
      puts "Stopping and Removing Containers..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customDown") == nil
        run("docker-compose down")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customDown") != nil
        run(Dkc::Config.instance.getValue("customDown"))
      end

    rescue StandardError => e
      puts e.message
      exit false
    end

    desc "start", "Start containers"
    def start
      puts "Starting Containers..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customStart") == nil
        run("docker-compose start")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customStart") != nil
        run(Dkc::Config.instance.getValue("customStart"))
      end

    rescue StandardError => e
      puts e.message
      exit false
    end

    desc "stop", "Stop containers"
    def stop
      puts "Stopping Containers..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customStop") == nil
        run("docker-compose stop")
      end

      if Dkc::Config.instance.getValue("usesCompose") == true && Dkc::Config.instance.getValue("customStop") != nil
        run(Dkc::Config.instance.getValue("customStop"))
      end

    rescue StandardError => e
      puts e.message
      exit false
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
      exit false
    end

    desc "logs", "Tail logs on containers in config"
    def logs
      puts "Tailing logs..."
      unless Dkc::Config.instance.load
        raise StandardError.new("ERROR: Could not load/parse #{CONFIG_FILE_NAME}")
      end

      log_containers = Dkc::Config.instance.getValue("logContainers")

      if log_containers.class != Array || log_containers.length <= 0
        raise StandardError.new("ERROR: No logContainers value in #{CONFIG_FILE_NAME}")
      end

      run("docker-compose logs -f #{log_containers.join(" ")}")

    rescue StandardError => e
      puts e.message
      exit false
    end
  end
end
