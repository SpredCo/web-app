class FollowUserRequest < PostRequest
  def initialize(tokens, id)
    req = APIHelper::Request::USER_FOLLOW
    super(tokens, req[:service], req[:end_point], id)
  end
end