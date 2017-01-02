class TokenBox
  attr_accessor :access_token, :refresh_token

  def initialize(access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
  end

  def reload!
    request = ReloadTokensRequest.new(@refresh_token)
    request.send
    response = request.parse_response
    if response.is_a? APIError
      response
    else
      @access_token = response.body['access_token']
      @refresh_token = response.body['refresh_token']
      true
    end
  end
end
