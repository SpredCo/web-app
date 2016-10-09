require_relative 'api_message'
require_relative 'api_success'
require_relative 'api_error'

require_relative 'requests/base_request'
require_relative 'requests/get_request'
require_relative 'requests/post_request'
require_relative 'requests/patch_request'

require_relative 'requests/check_email_request'
require_relative 'requests/check_pseudo_request'
require_relative 'requests/check_google_token_request'
require_relative 'requests/check_facebook_token_request'

require_relative 'requests/facebook_login_request'
require_relative 'requests/google_login_request'
require_relative 'requests/spred_login_request'
require_relative 'requests/reload_tokens_request'

require_relative 'requests/facebook_signup_request'
require_relative 'requests/google_signup_request'
require_relative 'requests/spred_signup_request'

require_relative 'requests/get_user_request'
require_relative 'requests/edit_user_request'
require_relative 'requests/search_user_by_email_request'
require_relative 'requests/search_user_by_pseudo_request'
require_relative 'requests/follow_user_request'
require_relative 'requests/unfollow_user_request'

require_relative 'requests/get_inbox_request'
require_relative 'requests/get_conversation_request'
require_relative 'requests/reply_conversation_request'
require_relative 'requests/get_message_request'
require_relative 'requests/create_conversation_request'
require_relative 'requests/read_conversation_request'

require_relative 'users/base_user'
require_relative 'users/remote_user'
require_relative 'users/current_user'

require_relative 'inbox/inbox'
require_relative 'inbox/conversation'
require_relative 'inbox/message'

require_relative 'token_box'
