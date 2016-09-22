class BaseUser
  attr_reader :id, :email, :first_name, :last_name, :picture

  def initialize(id, email, first_name, last_name, picture)
    @id = id
    @email = email
    @first_name = first_name
    @last_name = last_name
    @picture = picture
  end
end