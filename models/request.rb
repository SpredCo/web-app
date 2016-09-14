class Request
  require 'net/http'
  require 'json'

  ## session: Sinatra session
  ## request_type: Symbol(:login || :api)
  ## endpoint: String (ex: '/v1/oauth2/token')
  ## params: Hash (parameters for the request)
  def initialize(session, request_type, endpoint, params = nil)
    @session = session
    @uri = URI.parse(Spred.settings.send("#{request_type.to_s}_url") + endpoint)
  end

  def body
    @request.body
  end

  def send
    puts "send request to #{@uri} with method #{@request.method}, header #{a={}; @request.each_header{|head, v| a[head] = v }; a}, body #{@request.body}"
    puts 'With session: '
    @session.each_entry { |k| p k}
    @response = Net::HTTP.new(@uri.host, @uri.port).start do |http|
      # http.use_ssl = (@uri.scheme == "https")
      http.request(@request)
    end
    puts '*************************', @response.body, '*************************'
    begin
      @response.body = JSON.parse(@response.body)
    rescue JSON::ParserError => e
      puts "caught #{e}"
      refresh_token
      retry
    end
    puts 'check response'
    @response.each_key { |k| puts k, @response[k]}
    if APIError::ERRORS.has_key?(@response.code)
      return nil unless @response.body['code']
      return (APIError.new(@response.code, @response.body['code'], @response.body['sub_code'] || nil))
    end
    puts "reponse: #{@response.body}"
    @response
  end

  def response
    @response
  end

  def refresh_token
    Spred.redirect '/'
  end
end