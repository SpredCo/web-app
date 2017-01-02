class BaseRequest
  require 'net/http'
  require 'json'

  def initialize(tokens, endpoint)
    @uri = URI.parse(endpoint)
    @tokens = tokens
  end

  def body
    @request.body
  end

  def send
    puts "Send request to #{@uri} with body: #{body}"
    @response = Net::HTTP.new(@uri.host, @uri.port).start do |http|
      http.request(@request)
    end
    puts @response
    puts "Received #{@response.body}"
  end

  def parse_response
    begin
      @response.body = JSON.parse(@response.body)
    rescue JSON::ParserError => e
      p "Error: #{e} while parsing response"
      @tokens.reload!
      self.send
    end
    if APIError::ERRORS.has_key?(@response.code)
      return nil unless @response.body['code']
      return (APIError.new(@response.code, @response.body['code'], @response.body['sub_code'] || nil))
    end
    @response
  end
end
