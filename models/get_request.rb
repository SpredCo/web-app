class GetRequest < Request
  def initialize(session, request_type, endpoint)
    super(session, request_type, endpoint, nil)
    begin
      initialize_request(request_type)
    rescue => e
      raise e
    end
  end

  private

  def initialize_request(request_type)
    case request_type
      when :login
        @request = Net::HTTP::Get.new(@uri.path, 'Content-type' => 'application/json')
        @request.basic_auth(Spred.settings.client_key, Spred.settings.client_secret)
      when :api
        @request = Net::HTTP::Get.new(@uri.path, 'Content-type' => 'application/json', 'Authorization' => "Bearer #{@session[:current_user][:access_token]}")
      else
        raise "Cannot initialize request: bad request type - #{request_type}."
    end
  end
end