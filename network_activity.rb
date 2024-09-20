require_relative './activity'

class NetworkActivity < Activity
  def initialize(activity_info)
    super

    @data = activity_info['data']
  end

  def run
  end

  def to_log
  end
end
