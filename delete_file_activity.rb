require_relative './activity'

class DeleteFileActivity < Activity
  def command
    "rm #{attributes['path']}"
  end
end
