class CreateConversationRequest < PostRequest
  def initialize(tokens, conversation)
    req = Api::Request::CONVERSATION_CREATE
    super(tokens, req[:service], req[:end_points], conversation.to_h)
  end
end