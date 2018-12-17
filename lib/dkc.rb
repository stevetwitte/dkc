require "dkc/version"
require 'thor'

module Dkc
  class Error < StandardError; end
  # Your code goes here...
  class CLI < Thor
    desc "hello world", "my first cli yay"
    def hello
      puts "Hello world"
    end
  end
end
