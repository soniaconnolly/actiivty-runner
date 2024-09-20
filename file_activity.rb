require_relative './activity'

class FileActivity < Activity
  def initialize(activity_info)
    super

    @data = activity_info['data']
    @type = activity_info['type']
  end

  def run
  end

  def to_log
  end
end
