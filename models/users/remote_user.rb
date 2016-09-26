class RemoteUser < BaseUser
  attr_accessor :following

  def initialize(id, email=nil, first_name=nil, last_name=nil, picture=nil)
    @following = []
    super(id, email, first_name, last_name, picture)
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

  def self.find_by_id(tokens, id)
    request = GetUserRequest(tokens, id)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      init_from_hash(response.body)
    end
  end

  def self.init_from_hash(user_hashed)
    user = RemoteUser.new(user_hashed[:id], user_hashed[:email], user_hashed[:first_name], user_hashed[:last_name], user_hashed[:picture])
    user_hashed[:following].each do |follower|
      user.following << follower
    end
    user
  end
end