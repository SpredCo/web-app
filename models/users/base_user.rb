class BaseUser
  attr_reader :id, :email, :first_name, :last_name, :picture_url, :updated_at, :created_at

  def initialize(id, email, first_name, last_name, picture_url, update_at, created_at)
    @id = id
    @email = email
    @first_name = first_name
    @last_name = last_name
    @picture_url = picture_url
    @updated_at = update_at
    @created_at = created_at
  end

  def self.from_hash(user)
    BaseUser.new(user[:id], user[:email], user[:first_name], user[:last_name],
                 user[:picture_url], user[:updated_at], user[:created_at])
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
end