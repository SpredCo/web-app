class CheckPseudoRequest < GetRequest
  def initialize(pseudo)
    req = APIHelper::Request::CHECK_PSEUDO
    super(nil, req[:service], "#{req[:end_point]}/#{pseudo}")
  end
end