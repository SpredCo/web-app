class Request
  require 'net/http'
  require 'json'

  ## request_type: Symbol(:login || :api)
  ## endpoint: String (ex: '/v1/oauth2/token')
  ## params: Hash (parameters for the request)
  def initialize(request_type, endpoint, params = nil)
    @uri = URI.parse(Spred.settings.send("#{request_type.to_s}_url") + endpoint)
    @request = Net::HTTP::Post.new(@uri.path, 'Content-type' => 'application/json')
    @request.basic_auth(Spred.settings.client_key, Spred.settings.client_secret)
    @request.body = params.to_json if params
  end

  def body
    @request.body
  end

  def send
    @response = Net::HTTP.new(@uri.host, @uri.port).start {|http| http.request(@request) }
    @response.body = JSON.parse(@response.body)
    @response
  end

  def response
    @response
  end
end