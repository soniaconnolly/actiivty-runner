require_relative './activity'

class ModifyFileActivity < Activity
  def command
    "echo '#{attributes['data']}' >> #{attributes['path']}"
  end
end
