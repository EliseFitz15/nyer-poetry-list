configure do
  enable :sessions
  set :session_secret, 'SESSION_SECRET_CODE'
  set :views, 'app/views'
end
