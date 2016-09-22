class CurrentUser < BaseUser
  attr_accessor :access_token, :refresh_token

  def initialize(email, first_name, last_name, picture, access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
    super('me', email, first_name, last_name, picture)
  end

  def edit

  end

  def delete

  end
end