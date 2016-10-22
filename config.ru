# frozen_string_literal: true

require 'sinatra/base'
if Sinatra::Base.development?
  require 'dotenv'
  Dotenv.load
end

require 'sidekiq'
Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    url: ENV.fetch('REDIS_URL')
  }
end

require 'sinatra_auth_github'
module App
  class Web < Sinatra::Base
    enable :sessions

    set :github_options, scopes: 'user',
                         client_id: ENV.fetch('GITHUB_CLIENT_ID'),
                         secret: ENV.fetch('GITHUB_CLIENT_SECRET')

    register Sinatra::Auth::Github

    before /^(?:(?!((^\/logout)|((\.css|\.js)$))).)*$/ do
      authenticate!
      github_organization_authenticate! ENV.fetch('GITHUB_ORG')
    end

    get '/logout' do
      logout!
      redirect ENV.fetch('LOGOUT_REDIRECT_URL')
    end
  end
end

require 'sidekiq/web'
use App::Web

run Sidekiq::Web
