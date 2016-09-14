class APIError < APIMessage
  UNAUTHORIZED = 'You are not able to do this action'
  USER_NOT_FOUND = 'User not found'
  USER_NOT_FOLLOWED = 'You are not following this user'
  USER_ALREADY_FOLLOWED = 'You are already following this user'
  USER_EXISTS_EMAIL = 'Email already in use'
  USER_EXISTS_PSEUDO = 'Pseudo already in use'
  INVALID_REQUEST = 'Invalid request'
  CANNOT_UPDATE_EXTERNAL_EMAIL = 'You cannot update an email from a google or facebook account'
  INVALID_FACEBOOK_TOKEN = 'User facebook token is invalid'
  INVALID_GOOGLE_TOKEN = 'User google token is invalid'
  JSON_PARSE_ERROR = 'API dev sucks'
  INVALID_LOGIN = 'Email and password does not match'
  INVALID_REFRESH_TOKEN = 'Please re-login'

  ERRORS = {
      '400' => {
          '1' => INVALID_REQUEST,
          '2' => {
              '1' => INVALID_GOOGLE_TOKEN,
              '2' => INVALID_FACEBOOK_TOKEN,
              '4' => USER_ALREADY_FOLLOWED,
              '5' => USER_NOT_FOLLOWED
          }
      },
      '401' => {
          '2' => {
              '3' => CANNOT_UPDATE_EXTERNAL_EMAIL
          }
      },
      '403' => {
          '2' => {
              '1' => USER_EXISTS_EMAIL,
              '2' => USER_EXISTS_PSEUDO
          }
      },
      '404' => {
          '2' => {
              '1' => USER_NOT_FOUND
          }
      },
      '500' => {
          '1' => {
              '1' => JSON_PARSE_ERROR
          }
      }
  }

  def initialize(http_code, code, sub_code=nil)
    super(http_code)
    @code = code.to_s
    @sub_code = sub_code && sub_code.to_s
  end

  def set_message
    @message =  @sub_code ? ERRORS[@http_code][@code][@sub_code] : ERRORS[@http_code][@code]
  end
end