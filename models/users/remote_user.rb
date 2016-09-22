class RemoteUser < BaseUser

  def initialize(id, email, first_name, last_name, picture)
    super(id, email, first_name, last_name, picture)
  end

  def follow

  end

  def unfollow

  end

  def self.find_by_id(id)

  end
end