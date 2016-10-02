class CurrentUser < BaseUser
  attr_reader :following

  def initialize(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at, following)
    @following = following
    super(id, email, pseudo, first_name, last_name, picture_url, updated_at, created_at)
  end

  def edit!(tokens, params)
    EditUserRequest.new(tokens, params)
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