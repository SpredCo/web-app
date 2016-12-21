class Tag
  attr_reader :id, :name, :description

  def initialize(name, description, id)
    @name = name
    @description = description
    @id = id
  end

  def self.from_hash(tag)
    Tag.new(tag['name'], tag['description'], tag['id'])
  end

  def to_hash
    {
        name: @name,
        description: @description,
        id: @id
    }
  end

  def self.find_by_name(name)
    tag_req = GetTagByNameRequest.new(name)
    tag_req.send
    tag_response = tag_req.parse_response
    Tag.from_hash(tag_response.body)
  end

  def subscribed?(tokens)
    sub_req = CheckTagSubscriptionRequest.new(tokens, @id)
    sub_req.send
    sub_response = sub_req.parse_response
    sub_response.body['result']
  end
end
