require_relative './file_activity'
require_relative './activity'
require_relative './network_activity'
require_relative './null_activity'

class ActivityFactory
  def create(activity_info, logger)
    case activity_info['action']
    when 'run_process'
      Activity.new(activity_info, logger)
    when 'create_file', 'modify_file', 'delete_file'
      FileActivity.new(activity_info, logger)
    when 'network_request'
      NetworkActivity.new(activity_info, logger)
    else
      NullActivity.new(activity_info, logger)
    end
  end
end
