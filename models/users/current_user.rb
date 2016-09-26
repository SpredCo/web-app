class CurrentUser < BaseUser

  def initialize(id, email, first_name, last_name, picture)
    super(id, email, first_name, last_name, picture)
  end

  def edit!(tokens, params)
    EditUserRequest.new(tokens, params)
  end

  def delete

  end
end