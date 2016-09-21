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
    @response = Net::HTTP.new(@uri.host, @uri.port).start do |http|
      http.request(@request)
    end
    parse_response
  end

  def response
    @response
  end

  private

  def parse_response
    begin
      @response.body = JSON.parse(@response.body)
    rescue JSON::ParserError => e
      refresh_token
      retry
    end
    if APIError::ERRORS.has_key?(@response.code)
      return nil unless @response.body['code']
      return (APIError.new(@response.code, @response.body['code'], @response.body['sub_code'] || nil))
    end
    @response
  end

  def refresh_token
    req = PostRequest.new(@session, :login, ApiEndPoint::LOGIN, {'grant_type' => 'password', 'refresh_token' => session[:current_user]['refresh_token']})
    response = req.send
    if response.is_a?(APIError)
      @errors = { default: APIError::INVALID_REFRESH_TOKEN }
      redirect '/logout'
    end
  end
end