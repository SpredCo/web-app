class EditUserRequest < PatchRequest
  def initialize(tokens, params)
    req = APIHelper::Request::USER_EDIT
    super(tokens, req[:service], "#{req[:end_point]}/me", params)
  end
end