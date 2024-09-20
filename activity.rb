class Activity

  attr_reader :timestamp, :process_id, :process_owner, :location

  def initialize(activity_info)
    @action = activity_info['action']
    @path = activity_info['path']
  end

  def run
  end

  def to_log
  end
end
