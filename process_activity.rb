require 'etc'
require 'sys/proctable'
include Sys

require_relative './activity'

class ProcessActivity < Activity
  def run
    # See https://www.rubydoc.info/stdlib/core/Process.spawn for options that increase
    # security by limiting resources, changing process owner, etc.
    begin
      # stdout and stderr could be captured and logged in the same json format used elsewhere.
      process_id = Process.spawn(
        "#{attributes['path']} #{attributes['args']}",
        out: '/dev/null',
        err: '/dev/null'
        )

      attributes[:process_id] = process_id
      attributes[:process_start_time] = ProcTable.ps(process_id).starttime
      log_activity

      # Currently running everything synchronously. Could detach instead.
      Process.wait process_id
    rescue Exception => e
      log_activity(error: e.message)
    end
  end
end
