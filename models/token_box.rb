class TokenBox
  attr_accessor :access_token, :refresh_token

  def initialize(access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
  end

  def reload!

  end
end