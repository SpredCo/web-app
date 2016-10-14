class Conversation < BaseConversation
  attr_reader :msg

  def initialize(object, members, can_answer, last_msg, created_at, msg, read)
    super(object, members, can_answer, last_msg, created_at, read)
    @msg = msg
  end

  def self.create(id, object, members, can_answer, last_msg, created_at, msg, read)
    c = Conversation.new(object, members, can_answer, last_msg, created_at, msg, read)
    c.id = id
    c
  end

  def self.from_hash(conversation)
    members = conversation['members'].each_with_object([]) do |member, array|
      array << BaseUser.from_hash(member)
    end
    msg = conversation['msg'].each_with_object([]) do |member, array|
      array << Message.from_hash(member)
    end
    Conversation.create(conversation['id'], conversation['object'], members, conversation['can_answer'],
                     conversation['last_msg'], conversation['created_at'], msg, conversation['read'])
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
        msg: @msg.map(&:to_hash),
        read: @read
    }
  end
end