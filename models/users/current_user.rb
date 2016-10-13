class CurrentUser < BaseUser
  attr_reader :following

  def initialize(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at, following)
    @following = following
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
    if @inbox
      local_unread_convs = @inbox.unread_conversations.count
      remote_unread_convs = InboxUnreadMessagesRequest.new(tokens)
      @inbox = Inbox.reload(tokens) if local_unread_convs != remote_unread_convs
    else
      @inbox = Inbox.reload(tokens)
    end
    @inbox
  end

  def is_following?(pseudo)
    is_following = false
    @following.each do |user|
      if user.pseudo == pseudo
        is_following = true
        break
      end
    end
    is_following
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
      array << BaseUser.from_hash(follower)
    end
    CurrentUser.new(user_hashed['id'], user_hashed['email'], user_hashed['pseudo'],
                    user_hashed['first_name'], user_hashed['last_name'],
                    user_hashed['picture_url'], user_hashed['updated_at'], user_hashed['created_at'], following)
  end
end