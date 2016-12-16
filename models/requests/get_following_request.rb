class GetFollowingRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::USER_FOLLOWING
    super(tokens, req[:service], req[:end_point])
  end
end
