class PatchRequest < BaseRequest
  def initialize(tokens, request_type, endpoint, params = nil)
    super(tokens, endpoint)
    begin
      initialize_request(request_type)
    rescue => e
      raise e
    end
    @request.body = params.to_json if params
  end

  private

  def initialize_request(request_type)
    case request_type
      when :login
        @request = Net::HTTP::Patch.new(@uri.path, 'Content-type' => 'application/json')
        @request.basic_auth(Spred.settings.client_key, Spred.settings.client_secret)
      when :api
        @request = Net::HTTP::Patch.new(@uri.path, 'Content-type' => 'application/json', 'Authorization' => "Bearer #{@tokens.access_token}")
      else
        raise "Cannot initialize request: bad request type - #{request_type}."
    end
  end
end