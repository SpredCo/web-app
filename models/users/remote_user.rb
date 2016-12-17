class RemoteUser < BaseUser

  def initialize(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at)
    super(id, email, pseudo, first_name, last_name, picture_url,  updated_at, created_at)
  end

  def follow(tokens)
    request = FollowUserRequest.new(tokens, @id)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      self
    end
  end

  def unfollow(tokens)
    request = UnFollowUserRequest.new(tokens, @id)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      self
    end
  end

  def self.find(id)
    request = GetUserRequest.new(id)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      from_hash(response.body)
    end
  end

  def self.find_by_pseudo(pseudo)
    request = GetUserRequest.new("@#{pseudo}")
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      from_hash(response.body)
    end
  end

  def to_hash
    super
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

  def self.find_all_by_email(tokens, partial_email)
    request = SearchUserByEmailRequest.new(tokens, partial_email)
    request.send
    response = request.parse_response
    response.body.map {|user| from_hash(user)}
  end

  def self.find_all_by_pseudo(tokens, partial_pseudo)
    request = SearchUserByPseudoRequest.new(tokens, partial_pseudo)
    request.send
    response = request.parse_response
    response.body.map {|user| from_hash(user)}
  end

  def self.from_hash(user_hashed)
    RemoteUser.new(user_hashed['id'], user_hashed['email'], user_hashed['pseudo'],
                    user_hashed['first_name'], user_hashed['last_name'],
                    user_hashed['picture_url'], user_hashed['updated_at'], user_hashed['created_at'])
  end
end
