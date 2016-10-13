class Conversation
  attr_reader :object, :members, :can_answer, :last_msg, :created_at, :msg
  attr_accessor :id

  def initialize(object, members, can_answer, last_msg, created_at, msg)
    @object = object
    @members = members
    @can_answer = can_answer
    @last_msg = last_msg
    @created_at = created_at
    @msg = msg
  end

  def members_as_string
    members = ''
    @members.each do |member|
      members += ', ' unless members.empty?
      members += member.to_s
    end
    members
  end

  def self.create(id, object, members, can_answer, last_msg, created_at, msg)
    c = Conversation.new(object, members, can_answer, last_msg, created_at, msg)
    c.id = id
    c
  end

  def push(tokens, message)
    req = CreateMessageRequest.new(tokens, @id, message)
    req.send
    response = req.parse_response
    if response.is_a? APIError
      response
    else
      response.body
    end
  end

  def read!(tokens)
    req = ReadConversationRequest(tokens, @id)
    req.send
    req.parse_response
  end

  def unread?
    unread = false
    @msg.each {|message| unread = true if message.unread?}
    unread
  end

  def read?
    !unread?
  end

  def self.from_hash(conversation)
    members = conversation['members'].each_with_object([]) do |member, array|
      array << BaseUser.from_hash(member)
    end
    msg = conversation['msg'].each_with_object([]) do |member, array|
      array << Message.from_hash(member)
    end
    Conversation.create(conversation['id'], conversation['object'], members, conversation['can_answer'],
                     conversation['last_msg'], conversation['created_at'], msg)
  end

  def get_user_by_id(id)
    @members.select{|m| m.id == id}.first
  end

  def to_hash
    {
        object: @object,
        can_answer: @can_answer,
        last_msg: @last_msg,
        created_at: @created_at,
        members: @members.map(&:to_hash),
        msg: @msg.map(&:to_hash)
    }
  end
end