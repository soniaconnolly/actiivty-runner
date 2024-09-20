#! ruby

require 'activity_runner'

activities_file = ARGV[0]

if activities_file.nil?
  puts 'Usage: run_activities.rb activities_file.json'
  exit
end

ActivityRunner.new(activity_file).run
