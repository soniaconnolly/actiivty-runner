require_relative './activity'

class ProcessActivity < Activity
  def initialize(activity_info)
    super

    @args = activity_info['args']
  end

  def run
    # See https://www.rubydoc.info/stdlib/core/Process.spawn for options that increase
    # security by limiting resources, changing process owner, etc.
    begin
      # stdout and stderr should be captured and logged in the same json format used elsewhere.
      @process_id = Process.spawn("#{@path} #{@args}", out: '/dev/null', err: '/dev/null')

      # Currently running everything synchronously. Could detach instead.
      Process.wait @process_id
    rescue Exception => e
      # log error
    end
  end

  def to_log
  end
end
