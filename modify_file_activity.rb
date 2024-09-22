require_relative './activity'

# Modify a file at 'path' by appending the given 'data'
class ModifyFileActivity < Activity
  def command
    "echo '#{attributes['data']}' >> #{attributes['path']}"
  end
end
