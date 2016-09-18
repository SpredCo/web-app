module ApiEndPoint
  ##
  ## Login service
  ##
  SIGNUP = '/v1/users'
  CHECK_PSEUDO = '/v1/users/pseudo/check'
  CHECK_EMAIL = '/v1/users/email/check'
  FACEBOOK_SIGNUP = "#{SIGNUP}/facebook"
  GOOGLE_SIGNUP = "#{SIGNUP}/google"
  LOGIN = '/v1/oauth2/token'
  GOOGLE_LOGIN = '/v1/oauth2/google-connect'
  FACEBOOK_LOGIN = '/v1/oauth2/facebook-connect'

  ##
  ## API service
  ##
  USER = '/v1/users'
  SEARCH_BY_EMAIL = '/v1/users/search'
end