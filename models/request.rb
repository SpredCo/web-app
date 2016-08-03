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
    @response = Net::HTTP.new(@uri.host, @uri.port).start do |http|
      puts 'ok'
      # http.use_ssl = (@uri.scheme == "https")
      http.request(@request)
    end
    puts 'parse body'
    @response.body = JSON.parse(@response.body)
    @response
  end

  def response
    @response
  end
end