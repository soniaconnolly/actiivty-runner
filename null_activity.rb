require_relative './activity'

# This class is returned for invalid actions or missing paths.
class NullActivity < Activity
  def run
    log_activity
  end
end
