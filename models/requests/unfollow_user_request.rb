class UnFollowUserRequest < PostRequest
  def initialize(tokens, id)
    req = APIHelper::Request::USER_UNFOLLOW
    super(tokens, req[:service], "#{req[:end_point]}/#{id}/unfollow")
  end
end