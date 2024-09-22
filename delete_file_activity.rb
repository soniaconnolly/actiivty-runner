require_relative './activity'

# Delete a file specified by 'path'
class DeleteFileActivity < Activity
  def command
    "rm #{attributes['path']}"
  end
end
