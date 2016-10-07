class Message
  attr_reader :conversation, :from, :content, :created_at
  attr_accessor :id

  def initialize(conversation, from, content, read=false, created_at=DateTime.now)
    @conversation = conversation
    @from = from
    @content = content
    @read = read
    @created_at = created_at
  end

  def self.create(id, conversation, from, content, read=false, created_at=DateTime.now)
    m = Message.new(conversation, from, content, read, created_at)
    m.id = id
    m
  end

  def unread?
    !@read
  end

  def read?
    @read
  end

  def self.from_hash(message)
    Message.create(message['id'], message['conversation'], message['from'], message['content'], message['read'], message['created_at'])
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