require_relative './activity'
require_relative './network_activity'
require_relative './create_file_activity'
require_relative './modify_file_activity'
require_relative './delete_file_activity'
require_relative './null_activity'

class ActivityFactory
  # Create a class that corresponds to the desired command.
  # It would also be possible to require the class name to be used for activity_info['action']
  # and create the correct class from that instead of having a switch statement.
  def create(activity_info, logger)
    # Each class could do a validity check, but for now just require path
    if !activity_info['path']
      activity_info['error'] = 'Missing path'
      return NullActivity.new(activity_info, logger)
    end

    case activity_info['action']
    when 'run_process'
      Activity.new(activity_info, logger)
    when 'create_file'
      CreateFileActivity.new(activity_info, logger)
    when 'modify_file'
      ModifyFileActivity.new(activity_info, logger)
    when 'delete_file'
      DeleteFileActivity.new(activity_info, logger)
    when 'network_request'
      NetworkActivity.new(activity_info, logger)
    else
      activity_info['error'] = "Invalid action #{activity_info['action'].inspect}"
      NullActivity.new(activity_info, logger)
    end
  end
end
