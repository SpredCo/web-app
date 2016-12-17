class GetTagByNameRequest < GetRequest
  def initialize(name)
    req = APIHelper::Request::TAGS
    super(nil, req[:service], "#{req[:end_point]}/#{name}")
  end
end
