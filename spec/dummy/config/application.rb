# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "payflow"

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.2
    config.eager_load = false
    config.active_job.queue_adapter = :test
    config.secret_key_base = "test_secret"
  end
end
