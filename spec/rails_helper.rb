# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

ENGINE_ROOT = File.expand_path("../", __dir__)
ENGINE_PATH = File.expand_path("../lib/payflow/engine", __dir__)

require File.expand_path("dummy/config/environment", __dir__)
require "rspec/rails"
require "payflow"

Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |file| require file }

ActiveRecord::Migrator.migrations_paths = [
  File.expand_path("../db/migrate", __dir__),
  File.expand_path("dummy/db/migrate", __dir__)
]

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include ActiveJob::TestHelper

  config.before(:suite) do
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrate

    Payflow.configure do |payflow_config|
      payflow_config.default_provider = :asaas
      payflow_config.asaas_api_key = "test_key"
      payflow_config.asaas_webhook_token = "test_asaas_token"
      payflow_config.stripe_webhook_secret = "whsec_test"
    end
  end

  config.before do
    ActiveJob::Base.queue_adapter = :test
  end
end
