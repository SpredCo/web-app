class UnFollowUserRequest < PostRequest
  def initialize(tokens, id)
    req = Api::Request::USER_UNFOLLOW
    super(tokens, req[:service], req[:end_point], id)
  end
end