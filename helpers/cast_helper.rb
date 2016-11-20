class CastHelper
  def self.get_cast_token(tokens, id)
    if tokens.is_a? TokenBox
      req = GetCastTokenRequest.new(tokens, id)
    else
      req = GetGuestCastTokenRequest.new(id)
    end
    req.send
    req.parse_response
  end
end
