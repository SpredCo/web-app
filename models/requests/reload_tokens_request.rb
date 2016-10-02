class ReloadTokensRequest < PostRequest
  def initialize(refresh_token)
    req = APIHelper::Request::RELOAD_TOKENS
    super(nil, req[:service], req[:end_point], {grant_type: 'refresh_token', refresh_token: refresh_token})
  end
end