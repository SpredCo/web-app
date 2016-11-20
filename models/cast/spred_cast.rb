class SpredCast
  attr_reader :creator, :name, :description, :tags, :date, :members, :is_public, :duration, :user_capacity, :url, :cover_url

  def initialize(id, creator, name, description, tags, date, members, is_public, duration, user_capacity, url, cover_url)
    @id = id
    @creator = creator
    @name = name
    @description = description
    @tags = tags
    @date = date
    @members = members
    @is_public = is_public
    @duration = duration
    @user_capacity = user_capacity
    @url = url
    @cover_url = cover_url
  end

  def self.from_hash(tokens, cast)
    members = cast['members'].each_with_object([]) do |member_id, array|
      array << BaseUser.find(tokens, member_id)
    end
    creator = BaseUser.from_hash(cast['creator'])
    SpredCast.new(cast['id'], creator, cast['name'], cast['description'], cast['tags'], cast['date'],
                  members, cast['id_public'], cast['duration'], cast['user_capacity'], cast['url'], cast['cover_url'])
  end

  def to_hash
    {
      id: @id,
      creator: @creator,
      name: @name,
      description: @description,
      tags: @tags,
      date: @date,
      members: @members.map(&:id),
      id_public: @is_public,
      duration: @duration,
      user_capacity: @user_capacity,
      url: @url,
      cover_url: @cover_url
    }
  end
end
