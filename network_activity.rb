require 'uri'
require 'faraday'

class NetworkActivity < Activity
  def command
    # Port is specified as part of the url, and is also logged separately
    uri = URI.parse(attributes['path'])
    attributes['port'] = uri.port
    attributes['uri'] = uri.to_s

    # local port, should be a range, per
    # https://everything.curl.dev/usingcurl/connections/local-port.html


    # Assuming protocol means GET/POST method rather than scheme (HTTP, HTTPS, etc.).
    # DELETE and other methods could be added if needed
    if attributes['protocol']&.upcase == 'POST'
      # Tell curl to urlencode the data
      "curl --data-urlencode '#{attributes['data']}' #{uri.to_s}"
    else # default to GET
      uri.query = attributes['data']
      attributes['uri'] = uri.to_s
      "curl #{uri.to_s}"
    end
  end

  def run
    # Port is specified as part of the url, and is also logged separately
    uri = URI.parse(attributes['path'])
    attributes['port'] = uri.port
    attributes['uri'] = uri.to_s

    result = ''

    if attributes['protocol']&.upcase == 'POST'
      connection = Faraday.new "#{uri.scheme}://#{uri.host}"

      result = connection.post uri.path, attributes['data']
    else # default to GET
      uri.query = attributes['data']
      attributes['uri'] = uri.to_s
      attributes['protocol'] = 'GET'
      result = Faraday.get uri.to_s
    end

    attributes['status'] = result.status
    attributes['process_start_time'] = result.headers['date']
    attributes['content_length'] = result.headers['content-length'].to_i
    attributes['process_owner'] = process_owner
    attributes['process_name'] = process_name(Process.pid) # Request ran in current process
    attributes['process_id'] = Process.pid # Request ran in current process
    attributes['command'] = command # Show curl command corresponding to Faraday connection
    log_activity
  end
end
