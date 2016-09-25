class GetUserRequest < GetRequest
  def initialize(id)
    req = Api::Request::USER_GET
    super(req[:service], "#{req[:end_point]}/#{id}")
  end
end