require_relative './file_activity'
require_relative './process_activity'
require_relative './network_activity'
require_relative './null_activity'

class ActivityFactory
  def create(activity_info)
    case activity_info['action']
    when 'run_process'
      ProcessActivity.new(activity_info)
    when 'create_file', 'modify_file', 'delete_file'
      FileActivity.new(activity_info)
    when 'network_request'
      NetworkActivity.new(activity_info)
    else
      NullActivity.new(activity_info)
    end
  end
end
