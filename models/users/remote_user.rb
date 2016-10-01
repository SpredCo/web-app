class RemoteUser < BaseUser

  def initialize(id, email, first_name, last_name, picture_url, updated_at, created_at)
    @following = following
    super(id, email, first_name, last_name, picture_url,  updated_at, created_at)
  end

  def follow(tokens)
    request = FollowUserRequest(tokens, self.id)
    request.send
    request.parse_response
  end

  def unfollow(tokens)
    request = UnFollowUserRequest(tokens, self.id)
    request.send
    request.parse_response
  end

  def to_hash
    hash = super
    hash[:following] = @following.map(&:to_hash)
    hash
  end

  def self.find_by_id(tokens, id)
    request = GetUserRequest(tokens, id)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      from_hash(response.body)
    end
  end

  def self.from_hash(user_hashed)
    user = RemoteUser.new(user_hashed[:id], user_hashed[:email],
                          user_hashed[:first_name], user_hashed[:last_name],
                          user_hashed[:picture_url], user_hashed[:updated_at], user_hashed[:created_at])
    user_hashed[:following].each do |follower|
      user.following << BaseUser.from_hash(follower)
    end
    user
  end
end