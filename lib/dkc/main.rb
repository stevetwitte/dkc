require "thor"

module Dkc
  class Main < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "start", "Start Default Configuration"
    def start
      puts "Starting..."
      return true
    end
  end
end
