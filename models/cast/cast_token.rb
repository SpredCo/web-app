class CastToken
  def initialize(cast_token, spred_cast, presenter, pseudo)
    @cast_token = cast_token
    @spred_cast = spred_cast
    @presenter = presenter
    @pseudo = pseudo
  end

  def self.from_hash(cast_token)
    CastToken.new(cast_token[:cast_token], cast_token[:spred_cast], cast_token[:presenter], cast_token[:pseudo])
  end
end
