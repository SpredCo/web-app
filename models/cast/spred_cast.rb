class SpredCast
  attr_reader :id, :creator, :name, :description, :tags, :date, :members, :is_public, :duration, :user_capacity, :url, :cover_url, :state

  def initialize(id, creator, name, description, tags, date, members, is_public, duration, user_capacity, url, cover_url, state)
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
    @state = state
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
        cover_url: @cover_url,
        state: @state
    }
  end

  def self.from_hash(cast)
    members = cast['members'].each_with_object([]) do |member, array|
      array << BaseUser.from_hash(member)
    end
    creator = BaseUser.from_hash(cast['creator'])
    SpredCast.new(cast['id'], creator, cast['name'], cast['description'], cast['tags'], cast['date'],
                  members, cast['id_public'], cast['duration'], cast['user_capacity'], cast['url'], cast['cover_url'], cast['state'])
  end

  def has_reminder?(tokens)
    req = CheckCastRemindRequest.new(tokens, @id)
    req.send
    response = req.parse_response
    response.body['result']
  end

  def set_reminder(tokens, activate)
    req = if activate
            RemindCastRequest.new(tokens, @id)
          else
            UnremindCastRequest.new(tokens, @id)
          end
    req.send
    response = req.parse_response
    response.body
  end
end
