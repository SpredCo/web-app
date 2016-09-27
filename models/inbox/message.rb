class Message
  attr_reader :conv, :from, :content, :read, :created_at

  def initialize(conv, from, content, read, created_at)
    @conv = conv
    @from = from
    @content = content
    @read = read
    @created_at = created_at
  end

  def self.find_by_id(tokens, id)

  end
end