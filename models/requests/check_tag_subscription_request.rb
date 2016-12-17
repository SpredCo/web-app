class CheckTagSubscriptionRequest < GetRequest
  def initialize(tokens, id)
    req = APIHelper::Request::TAGS
    super(tokens, req[:service], "#{req[:end_point]}/#{id}/subscription")
  end
end
