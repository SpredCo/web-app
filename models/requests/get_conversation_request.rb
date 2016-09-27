class GetConversationRequest < GetRequest
  def initialize(tokens, id)
    req = Api::Request::CONVERSATION_GET
    super(tokens, req[:service], req[:end_point] + "/#{id}")
  end
end