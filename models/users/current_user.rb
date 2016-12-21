class CurrentUser < BaseUser

  def initialize(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at)
    @inbox = nil
    super(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at)
  end

  def edit!(tokens, params)
    req = EditUserRequest.new(tokens, params)
    req.send
    response = req.parse_response
    unless response.is_a? APIError
      @id = response.body['id']
      @email = response.body['email']
      @pseudo = response.body['pseudo']
      @first_name = response.body['first_name']
      @last_name = response.body['last_name']
      @updated_at = response.body['updated_at']
      self
    end
  end

  def inbox(tokens)
    @inbox = Inbox.reload(tokens)
  end

  def is_following?(tokens, id)
    req = IsFollowingRequest.new(tokens, id)
    req.send
    response = req.parse_response
    response.body['result']
  end

  def delete

  end

  def following
    req = GetUserFollowingRequest.new(@id)
    req.send
    response = req.parse_response
    response.body.each_with_object([]) do |user, array|
      array << BaseUser.from_hash(user['following'])
    end
  end

  def followers
    req = GetUserFollowerRequest.new(@id)
    req.send
    response = req.parse_response
    response.body.each_with_object([]) do |user, array|
      array << BaseUser.from_hash(user['user'])
    end
  end

  def add_tag(tokens, tag_id)
    req = RegisterTagRequest.new(tokens, tag_id)
    req.send
    req.parse_response
  end

  def remove_tag(tokens, tag_id)
    req = UnregisterTagRequest.new(tokens, tag_id)
    req.send
    req.parse_response
  end

  def to_hash
    super
  end

  def self.from_hash(user_hashed)
    CurrentUser.new(user_hashed['id'], user_hashed['email'], user_hashed['pseudo'],
                    user_hashed['first_name'], user_hashed['last_name'],
                    user_hashed['picture_url'], user_hashed['updated_at'], user_hashed['created_at'])
  end
end
