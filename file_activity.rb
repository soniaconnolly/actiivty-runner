require_relative './activity'

class FileActivity < Activity
  def run
    begin

    rescue Exception => e
      log(error: e.message)
    end
  end
end
