class CurrentUser < BaseUser
  attr_reader :following

  def initialize(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at, following)
    @following = following
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

  # TODO: Compare unread messages to be sure the update is mandatory
  def inbox(tokens)
    req = GetInboxRequest.new(tokens)
    req.send
    response = req.parse_response
    response.is_a?(APIError) ? nil : Inbox.from_hash(response.body)
  end

  def delete

  end

  def to_hash
    hash = super
    hash[:following] = @following.map(&:to_hash)
    hash
  end

  def self.from_hash(user_hashed)
    following = user_hashed['following'].each_with_object([]) do |follower, array|
      #array << BaseUser.from_hash(follower)
    end
    CurrentUser.new(user_hashed['id'], user_hashed['email'], user_hashed['pseudo'],
                    user_hashed['first_name'], user_hashed['last_name'],
                    user_hashed['picture_url'], user_hashed['updated_at'], user_hashed['created_at'], following)
  end
end