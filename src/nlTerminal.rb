#!/usr/bin/env ruby

require 'optparse'
require_relative 'main'
#Treat::Core::Installer.install 'english'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: nlTerminal [OPTIONS]"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-s","--start","Start the terminal") do
    puts "Starting the terminal ..."
    Interpret.new.run
  end

  opt.on("-d","--debug","Enable debugging") do
    puts "Debug mode : ON"
  end

  opt.on("-h","--help","help!!") do
    puts opt_parser
  end
end

puts opt_parser if ARGV.empty?

opt_parser.parse!
