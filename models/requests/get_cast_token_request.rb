class GetCastTokenRequest < PostRequest
  def initialize(tokens, cast_id, presenter=nil)
    req = APIHelper::Request::CAST
    super(tokens, req[:service], "#{req[:end_point]}/#{cast_id}/token", {presenter: presenter})
  end
end
