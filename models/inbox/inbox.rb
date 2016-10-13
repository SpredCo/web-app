class Inbox
  attr_reader :conversations

  def initialize(conversations=nil)
    @conversations = conversations || []
  end

  def self.reload(tokens)
    req = GetInboxRequest.new(tokens)
    req.send
    response = req.parse_response
    response.is_a?(APIError) ? nil : Inbox.from_hash(response.body)
  end

  def unread_conversations
    @conversations.select {|conv| conv.unread?}
  end

  def create_conversation(tokens, members, object, content)
    req = CreateConversationRequest.new(tokens, members, object, content)
    req.send
    response = req.parse_response
    if response.is_a? APIError
      response
    else
      response.body
    end
  end

  def conversation(id)
    @conversations.select{|conv| conv.id == id}.first
  end

  def self.from_hash(inbox)
    conversations = inbox.each_with_object([]) do |conv, array|
      array << Conversation.from_hash(conv)
    end
    Inbox.new(conversations)
  end

  def to_hash
    @conversations.map(&:to_hash)
  end
end