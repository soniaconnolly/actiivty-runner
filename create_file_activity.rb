require_relative './activity'

class CreateFileActivity < Activity
  def command
    "touch #{attributes['path']}"
  end
end
