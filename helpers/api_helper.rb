module APIHelper
  SCHEME = 'http'
  URL = 'sharemyscreen.fr:3000'
  module EndPoint
    # Login Service
    SPRED_SIGNUP = '/v1/users'
    FACEBOOK_SIGNUP = "#{SPRED_SIGNUP}/facebook"
    GOOGLE_SIGNUP = "#{SPRED_SIGNUP}/google"

    SPRED_LOGIN = '/v1/oauth2/token'
    GOOGLE_LOGIN = '/v1/oauth2/google-connect'
    FACEBOOK_LOGIN = '/v1/oauth2/facebook-connect'

    CHECK_PSEUDO = '/v1/users/check/pseudo'
    CHECK_EMAIL = '/v1/users/check/email'
    CHECK_FACEBOOK_TOKEN = '/v1/users/check/facebook-token'
    CHECK_GOOGLE_TOKEN = '/v1/users/check/google-token'

    # API Service
    USER = '/v1/users'
    SEARCH_BY_EMAIL = '/v1/users/search/email'
    SEARCH_BY_PSEUDO = '/v1/users/search/pseudo'

    INBOX = '/v1/inbox'
    INBOX_UNREAD_MESSAGES = INBOX + '/unread'
    CONVERSATION = '/v1/inbox/conversation'

    CAST = '/v1/spredcast'
  end

  module Service
    LOGIN = 'login'
    API = 'api'
  end

  module Request
    SPRED_SIGNUP = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::SPRED_SIGNUP}"}
    FACEBOOK_SIGNUP = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::FACEBOOK_SIGNUP}"}
    GOOGLE_SIGNUP = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::GOOGLE_SIGNUP}"}

    SPRED_LOGIN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::SPRED_LOGIN}"}
    RELOAD_TOKENS = SPRED_LOGIN
    FACEBOOK_LOGIN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::FACEBOOK_LOGIN}"}
    GOOGLE_LOGIN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::GOOGLE_LOGIN}"}
    
    CHECK_EMAIL = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_EMAIL}"}
    CHECK_PSEUDO = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_PSEUDO}"}
    CHECK_FACEBOOK_TOKEN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_FACEBOOK_TOKEN}"}
    CHECK_GOOGLE_TOKEN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_GOOGLE_TOKEN}"}

    USER_GET = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_EDIT = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_DELETE = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_FOLLOW = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_UNFOLLOW = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_REPORT = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}

    INBOX = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    INBOX_UNREAD_MESSAGES = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::INBOX_UNREAD_MESSAGES}"}
    CONVERSATION_GET = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    CONVERSATION_REPLY = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    CONVERSATION_CREATE = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    MESSAGE_GET = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    MESSAGE_CREATE = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}
    READ_CONVERSATION = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CONVERSATION}"}

    SEARCH_USER_BY_EMAIL = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::SEARCH_BY_EMAIL}"}
    SEARCH_USER_BY_PSEUDO = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::SEARCH_BY_PSEUDO}"}

    CAST = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::CAST}"}
  end
end