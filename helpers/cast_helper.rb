module CastHelper
  require 'securerandom'

  def self.get_cast_token(tokens, id)
    if tokens.is_a? TokenBox
      req = GetCastTokenRequest.new(tokens, id)
    else
      req = GetGuestCastTokenRequest.new(id)
    end
    req.send
    req.parse_response
  end

  def self.generate_uniq_cover_url(file_ext)
    "cast_covers/#{SecureRandom.uuid}.#{file_ext}"
  end

  def self.save_cover(path, file)
    File.open("public/#{path}", 'w') do |f|
      f.write(file.read)
    end
  end
end
