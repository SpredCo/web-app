class GetGuestCastTokenRequest < PostRequest
  def initialize(tokens, cast_id)
    req = APIHelper::Request::GUEST_CAST
    super(tokens, req[:service], "#{req[:end_point]}/#{cast_id}/token", {presenter: false})
  end
end