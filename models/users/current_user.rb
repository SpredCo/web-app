class CurrentUser < BaseUser

  def initialize(id, email, first_name, last_name, picture, access_token, refresh_token)
    @token_box = TokenBox.new(access_token, refresh_token)
    super(id, email, first_name, last_name, picture)
  end

  def edit!(params)
    EditUserRequest.new(params)
  end

  def delete

  end

  def reload_tokens
    @token_box.reload!
  end

  def access_token
    @token_box.access_token
  end

  def refresh_token
    @token_box.refresh_token
  end
end