class GetMyFeedRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::MY_FEED
    super(tokens, req[:service], "#{req[:end_point]}/subscription")
  end
end
