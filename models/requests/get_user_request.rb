class GetUserRequest < GetRequest
  def initialize(tokens, id)
    req = Api::Request::USER_GET
    super(tokens, req[:service], "#{req[:end_point]}/#{id}")
  end
end