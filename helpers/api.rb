module Api
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

    CHECK_PSEUDO = '/v1/users/pseudo/check'
    CHECK_EMAIL = '/v1/users/email/check'

    # API Service
    USER = '/v1/users'
    SEARCH_BY_EMAIL = '/v1/users/search'
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
    FACEBOOK_LOGIN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::FACEBOOK_LOGIN}"}
    GOOGLE_LOGIN = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::GOOGLE_LOGIN}"}
    
    CHECK_EMAIL = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_EMAIL}"}
    CHECK_PSEUDO = {service: Service::LOGIN.to_sym, end_point: "#{SCHEME}://#{Service::LOGIN}.#{URL}#{EndPoint::CHECK_PSEUDO}"}

    USER_GET = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_EDIT = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_DELETE = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_FOLLOW = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_UNFOLLOW = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
    USER_REPORT = {service: Service::API.to_sym, end_point: "#{SCHEME}://#{Service::API}.#{URL}#{EndPoint::USER}"}
  end
end