require_relative './activity'

# Create a file of the specified type in the specified location.
# 'path' is a full path to the new file, including extension, which will specify type
class CreateFileActivity < Activity
  def command
    "touch #{attributes['path']}"
  end
end
