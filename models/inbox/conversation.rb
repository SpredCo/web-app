class Conversation
  attr_reader :messages

  def initialize(messages)
    @messages = messages.each_with_object([]) do |message, array|
      array << message
    end
  end

  def self.create

  end

  def self.find_by_id(tokens, id)

  end
end