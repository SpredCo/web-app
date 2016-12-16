class IsFollowingRequest < GetRequest
  def initialize(tokens, id)
    req = APIHelper::Request::USER_GET
    super(tokens, req[:service], "#{req[:end_point]}/#{id}/follow")
  end
end
