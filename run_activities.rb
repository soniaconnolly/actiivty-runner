#! ruby

require_relative './activity_runner'

activities_file = ARGV[0]

if activities_file.nil?
  puts 'Usage: run_activities.rb activities.json'
  exit
end

ActivityRunner.new(activities_file).run
