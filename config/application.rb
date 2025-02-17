require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Muse
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.active_job.queue_adapter = :sidekiq
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
