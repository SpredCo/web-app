class ReloadTokensRequest < PostRequest
  def initialize(refresh_token)
    req = Api::Request::RELOAD_TOKENS
    super(nil, req[:service], req[:end_point], refresh_token)
  end
end