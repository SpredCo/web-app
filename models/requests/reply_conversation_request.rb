class ReplyConversationRequest < PostRequest
  def initialize(tokens, message)
    req = APIHelper::Request::CONVERSATION_REPLY
    super(tokens, req[:service], req[:end_point], JSON.generate(message.to_h))
  end
end