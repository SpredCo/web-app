class CreateConversationRequest < PostRequest
  def initialize(tokens, members, object, content)
    req = APIHelper::Request::CONVERSATION_CREATE
    super(tokens, req[:service], req[:end_point], {members: members, object: object, content: content})
  end
end