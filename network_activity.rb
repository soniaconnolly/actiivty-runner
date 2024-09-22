require 'uri'

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
end
