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

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_USERNAME"))) &
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_PASSWORD")))
  end

  run Sidekiq::Web
end
