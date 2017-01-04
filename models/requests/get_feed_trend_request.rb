class GetFeedTrendRequest < GetRequest
  def initialize
    req = APIHelper::Request::FEED
    super(nil, req[:service], "#{req[:end_point]}/trend")
  end
end
