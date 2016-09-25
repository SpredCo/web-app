class PostRequest < BaseRequest

  def initialize(service, endpoint, params = nil)
    super(endpoint)
    begin
      initialize_request(service)
    rescue => e
      raise e
    end
    @request.body = params.to_json if params
  end

  private

  def initialize_request(service)
    case service
      when :login
        @request = Net::HTTP::Post.new(@uri, 'Content-type' => 'application/json')
        @request.basic_auth(Spred.settings.client_key, Spred.settings.client_secret)
      when :api
        @request = Net::HTTP::Post.new(@uri, 'Content-type' => 'application/json', 'Authorization' => "Bearer #{$session[:current_user].access_token}")
      else
        raise "Cannot initialize request: bad request type - #{service}."
    end
  end
end