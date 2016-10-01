class Message
  attr_reader :conversation, :from, :content, :read, :created_at

  def initialize(conversation, from, content, read, created_at)
    @conversation = conversation
    @from = from
    @content = content
    @read = read
    @created_at = created_at
  end

  def self.find_by_id(tokens, id)

  end

  def self.from_hash(message)
    Message.new(message[:conversation], message[:from], message[:content], message[:read], message[:created_at])
  end

  def to_hash
    {
        conversation: @conversation,
        from: @from,
        content: @content,
        read: @read,
        created_at: @created_at
    }
  end
end