class CurrentUser < BaseUser

  def initialize(id, email, first_name, last_name, picture_url, updated_at, created_at, following)
    @inbox = Inbox.new
    @following = following
    super(id, email, first_name, last_name, picture_url, updated_at, created_at)
  end

  def edit!(tokens, params)
    EditUserRequest.new(tokens, params)
  end

  def delete

  end
end