class GetCastsFromTagRequest < GetRequest
  def initialize(tag)
    req = APIHelper::Request::CASTS_BY_TAG
    super(nil, req[:service], req[:end_point] + "/#{tag}")
  end
end
