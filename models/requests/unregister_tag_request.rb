class UnregisterTagRequest < DeleteRequest
  def initialize(tokens, id)
    req = APIHelper::Request::MY_TAG
    super(tokens, req[:service], "#{req[:end_point]}/#{id}/subscription")
  end
end
