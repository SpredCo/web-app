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
end
