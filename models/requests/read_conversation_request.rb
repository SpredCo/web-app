class ReadConversationRequest < PatchRequest
  def initialize(tokens, id, read=true)
    req = APIHelper::Request::READ_CONVERSATION
    super(tokens, req[:service], "#{req[:end_point]}/#{id}/read", {read: read})
  end
end