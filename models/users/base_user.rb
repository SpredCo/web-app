class BaseUser
  attr_reader :id, :email, :pseudo, :first_name, :last_name, :picture_url, :updated_at, :created_at

  def initialize(id, email, pseudo, first_name, last_name, picture_url, update_at, created_at)
    @id = id
    @email = email
    @pseudo = pseudo
    @first_name = first_name
    @last_name = last_name
    @picture_url = picture_url
    @updated_at = update_at
    @created_at = created_at
  end

  def self.from_hash(user)
    BaseUser.new(user['id'], user['email'], user['pseudo'], user['first_name'], user['last_name'],
                 user['picture_url'], user['updated_at'], user['created_at'])
  end

  def to_hash
    {
        id: @id,
        email: @email,
        first_name: @first_name,
        last_name: @last_name,
        picture_url: @picture_url,
        updated_at: @updated_at,
        created_at: @created_at
    }
  end

  def self.find(tokens, identifier)
    req = GetUserRequest.new(tokens, identifier)
    req.send
    response = req.parse_response
    if response.is_a? APIError
      response
    else
      from_hash(response.body)
    end
  end

  def to_s
    "@#{@pseudo}"
  end
end