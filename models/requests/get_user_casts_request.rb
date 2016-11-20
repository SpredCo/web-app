class GetUserCastsRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::MY_CAST
    super(tokens, req[:service], req[:end_point])
  end
end
