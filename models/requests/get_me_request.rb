class GetMeRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::ME
    super(tokens, req[:service], "#{req[:end_point]}/me")
  end
end
