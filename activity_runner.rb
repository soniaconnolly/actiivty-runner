require 'json'
require 'json_logger'

require_relative './activity_factory'

# Given a JSON file with activities, run the activities
# Activities: run a process, create/modify/delete a file, or make a network connection
# If desired, change the name and location of the log file. Logging is in JSON format.
# Allow dependency injection for the ActivityFactory for specs
class ActivityRunner
  def initialize(
    activity_file,
    logfile: './activity_runner_log.json',
    factory: ActivityFactory.new
    )
    @activity_file = activity_file
    @factory = factory

    @logger = JsonLogger.factory(device: logfile, level: Logger::INFO)
  end

  def run
    load_activities.each do |activity|
      activity.run
    end
  end

  private

  def load_activities
    begin
      activities_json = File.read(@activity_file)
      activities_info = JSON.parse(activities_json)

      # Create an Activity of the appropriate type for each activity in the file
      activities_info.map do |activity_info|
        @factory.create(activity_info, @logger)
      end
    rescue IOError, SystemCallError => e
      raise ArgumentError.new("Invalid JSON file, error: #{e.message}")
    end
  end
end
