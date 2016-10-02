class GetConversationRequest < GetRequest
  def initialize(tokens, id)
    req = APIHelper::Request::CONVERSATION_GET
    super(tokens, req[:service], req[:end_point] + "/#{id}")
  end
end