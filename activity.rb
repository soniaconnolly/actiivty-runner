require 'etc'
require 'sys/proctable'

# Run a process and log the attributes to the given logger (expected to be a json logger)
class Activity
  include Sys

  attr_reader :attributes

  def initialize(attributes, logger)
    @attributes = attributes
    @logger = logger
  end

  # The command to run as a separate process.
  # Override in child classes as needed.
  def command
    "#{attributes['path']} #{attributes['args']}"
  end

  # Run a command as a separate process and save the process id, owner, and start time.
  def run
    # See https://www.rubydoc.info/stdlib/core/Process.spawn for options that increase
    # security by limiting resources, changing process owner, etc.
    begin
      # stdout and stderr could be captured and logged in the same json format used elsewhere.
      process_id = Process.spawn(command, out: '/dev/null', err: '/dev/null')

      attributes[:process_start_time] = get_process_start_time(process_id)
      attributes[:process_owner] = Etc.getpwuid(Process.uid).name
      attributes[:process_name] = ProcTable.ps(pid: process_id).name
      attributes[:command] = command
      attributes[:process_id] = process_id
      log_activity

      # Currently running everything synchronously. Could detach instead.
      Process.wait process_id
    rescue Exception => e
      log_activity(error: e.message)
    end
  end

  def log_activity(**extra)
    @logger.info(attributes.merge(extra))
  end

  private

  # ref: https://stackoverflow.com/questions/13017414/ruby-method-for-getting-a-processs-start-time
  # TODO: Convert to a timestamp
  def get_process_start_time(process_id)
    process_info = ProcTable.ps(pid: process_id)
    # :start_tvsec, :start_tvusec for Darwin
    # :starttime for Linux
    if process_info.respond_to?(:starttime)
      process_info.starttime
    elsif process_info.respond_to?(:start_tvsec)
      "#{process_info.start_tvsec} #{process_info.start_tvusec}"
    else
      'see log timestamp'
    end
  end
end
