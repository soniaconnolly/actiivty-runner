require 'etc'
require 'sys/proctable'

# Activity is the parent class for all the activities. Most activities just override #command,
# but some override #run
# Run a process specified in 'path' (does not have to be a full path) with optional 'args'.
# Log the attributes to the given logger (expected to be a json logger)
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
  # This can also be overriden in child classes.
  def run
    # See https://www.rubydoc.info/stdlib/core/Process.spawn for options that increase
    # security by limiting resources, changing process owner, etc.
    begin
      # stdout and stderr could be captured and logged in the same json format used elsewhere.
      process_id = Process.spawn(command, out: '/dev/null', err: '/dev/null')

      # The process has to run long enough to get the first three attributes.
      # Call get_process_start_time last because it's slow.
      attributes[:process_owner] = process_owner
      attributes[:process_name] = process_name(process_id)
      attributes[:process_start_time] = process_start_time(process_id)
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

  # Get the process start time in UTC on both Mac and Linux by calling ps. This is slow.
  # In a production system, use ProcTable and do the calculations to get the start time
  # from the provided values and the machine uptime.
  # For Linux, there's a gem get_process_start_time.
  # ref: https://stackoverflow.com/questions/13017414/ruby-method-for-getting-a-processs-start-time
  def process_start_time(process_id)
    `TZ=UTC LC_TIME=C ps -o lstart= -p #{process_id}`.strip
  end

  # Get the process name from the ProcTable for the given process_id.
  def process_name(process_id)
    ProcTable.ps(pid: process_id).name
  end

  # Owner is the same as for the current process
  # If the owner for the spawned processes is changed, this method would have to change.
  def process_owner
    Etc.getpwuid(Process.uid).name
  end
end
