class Activity
  attr_reader :attributes

  def initialize(attributes, logger)
    @attributes = attributes
    @logger = logger

    attributes[:process_id] = Process.pid
    attributes[:process_owner] = Etc.getpwuid(Process.uid).name
  end

  def run
  end

  def log_activity(**extra)
    @logger.info(attributes.merge(extra))
  end
end
