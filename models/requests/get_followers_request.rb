class GetFollowersRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::USER_FOLLOWER
    super(tokens, req[:service], req[:end_point])
  end
end
