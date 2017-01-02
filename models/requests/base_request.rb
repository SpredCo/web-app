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
    puts "Tokens: #{@tokens.access_token if @tokens}"
    @response = Net::HTTP.new(@uri.host, @uri.port).start do |http|
      http.request(@request)
    end
    if @response
      puts '@response is not null', @response.class
    else
      puts 'null'
      puts @response
    end
    puts "Received #{@response.body}"
  end

  def parse_response
    begin
      @response.body = JSON.parse(@response.body)
    rescue JSON::ParserError => e
      p "Error: #{e} while parsing response"

      req = self.class.send(:new, @tokens.reload!)
      req.send
      @response = req.parse_response
    end
    if APIError::ERRORS.has_key?(@response.code)
      return nil unless @response.body['code']
      return (APIError.new(@response.code, @response.body['code'], @response.body['sub_code'] || nil))
    end
    @response
  end
end
