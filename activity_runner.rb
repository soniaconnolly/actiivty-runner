require 'json'
require 'logger'

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
    @logfile = logfile
    @factory = factory
  end

  def run
    initialize_json_log

    load_activities.each do |activity|
      activity.run
    end
  end

  private

  # Log in json format
  def initialize_json_log
    @logger ||= Logger.new(@logfile)
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, progname, msg|
      formatted_date = datetime.strftime('%Y-%m-%dT%H:%M:%S.%6N')
      {
        timestamp: formatted_date,
        level: severity.ljust(5),
        pid: Process.pid,
        msg: msg
      }.to_json + "\n"
    end
  end

  def load_activities
    begin
      file = File.read(@activity_file)
      activities_info = JSON.parse(file)

      # Create an Activity of the appropriate type for each activity in the file
      activities_info.map do |activity_info|
        @factory.create(activity_info)
      end
    rescue IOError, SystemCallError => e
      raise ArgumentError.new("Invalid JSON file, error: #{e.message}")
    end
  end
end
