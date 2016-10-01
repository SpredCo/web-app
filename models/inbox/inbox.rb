class Inbox
  def initialize(conversations=nil)
    @conversations = conversations || []
  end

  def all_conversations(tokens)

  end

  def get_message(tokens, conv_id, msg_id)

  end

  def reply(conv_id)

  end

  def create_conversation

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