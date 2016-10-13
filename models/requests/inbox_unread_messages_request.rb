class InboxUnreadMessagesRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::INBOX_UNREAD_MESSAGES
    super(tokens, req[:service], req[:end_point])
  end
end