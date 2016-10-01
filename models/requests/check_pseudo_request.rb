class CheckPseudoRequest < GetRequest
  def initialize(pseudo)
    req = Api::Request::CHECK_PSEUDO
    super(nil, req[:service], "#{req[:end_point]}/#{pseudo}")
  end
end