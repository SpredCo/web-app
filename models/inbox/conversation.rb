class Conversation
  attr_reader :object, :members, :can_answer, :last_msg, :created_at, :msg

  def initialize(object, members, can_answer, last_msg, created_at, msg)
    @object = object
    @members = members
    @can_answer = can_answer
    @last_msg = last_msg
    @created_at = created_at
    @msg = msg
  end

  def self.create

  end

  def self.find_by_id(tokens, id)

  end

  def self.from_hash(conversation)
    members = conversation[:members].each_with_object([]) do |member, array|
      array << BaseUser.from_hash(member)
    end
    msg = conversation[:msg].each_with_object([]) do |member, array|
      array << Message.from_hash(member)
    end
    Conversation.new(conversation[:object], members, conversation[:can_answer],
                     conversation[:last_msg], conversation[:created_at], msg)
  end

  def to_hash
    {
        object: @object,
        can_answer: @can_answer,
        late_msg: @late_msg,
        created_at: @created_at,
        members: @members.map(&:to_hash),
        msg: @msg.map(&:to_hash)
    }
  end
end