require 'sidekiq'
require 'sidekiq/web'
require 'sinatra_auth_github'

Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    url: ENV['REDIS_URL']
  }
end

module Sidekiq
  class Web
    set :github_options, scopes: 'user',
                         client_id: ENV['GITHUB_CLIENT_ID'],
                         secret: ENV['GITHUB_CLIENT_SECRET']

    register Sinatra::Auth::Github

    before do
      authenticate!
      github_organization_authenticate!(ENV['GITHUB_ORG']) if ENV['GITHUB_ORG']
    end

    get '/logout' do
      logout!
      redirect ENV['LOGOUT_REDIRECT_URL']
    end
  end
end

run Sidekiq::Web
