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
      raise IOError
    end
    if @response.body.has_key?('error')
      raise IOError
    end
    puts "reponse: #{@response.body}"
    @response
  end

  def response
    @response
  end
end