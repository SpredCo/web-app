class EditUserRequest < PatchRequest
  def initialize(params)
    req = Api::Request::USER_EDIT
    super(req[:service], "#{req[:end_point]}/me", params)
  end
end