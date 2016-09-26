class GetRequest < BaseRequest

  def initialize(tokens, service, endpoint)
    super(tokens, endpoint)
    begin
      initialize_request(service)
    rescue => e
      raise e
    end
  end

  private

  def initialize_request(service)
    case service
      when :login
        @request = Net::HTTP::Get.new(@uri, 'Content-type' => 'application/json')
        @request.basic_auth(Spred.settings.client_key, Spred.settings.client_secret)
      when :api
        @request = Net::HTTP::Get.new(@uri, 'Content-type' => 'application/json', 'Authorization' => "Bearer #{@tokens.access_token}")
      else
        raise "Cannot initialize request: bad request type - #{service}."
    end
  end
end