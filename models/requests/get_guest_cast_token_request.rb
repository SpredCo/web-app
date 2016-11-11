class GetGuestCastTokenRequest < PostRequest
  def initialize(cast_id)
    req = APIHelper::Request::GUEST_CAST
    super(nil, req[:service], "#{req[:end_point]}/#{cast_id}/token", {presenter: false})
  end
end
