class GetTagsRequest < GetRequest
  def initialize
    req = APIHelper::Request::TAGS
    super(nil, req[:service], req[:end_point])
  end
end
