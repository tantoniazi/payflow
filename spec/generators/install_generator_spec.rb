# frozen_string_literal: true

require "rails_helper"
require "rails/generators/test_case"
require "generators/payflow/install_generator"

RSpec.describe Payflow::Generators::InstallGenerator do
  include FileUtils
  include Rails::Generators::Testing::Behavior
  include Rails::Generators::Testing::SetupAndTeardown
  include Rails::Generators::Testing::Assertions

  tests Payflow::Generators::InstallGenerator
  destination File.expand_path("../tmp/generator", __dir__)

  before { prepare_destination }

  it "creates the initializer" do
    run_generator

    assert_file "config/initializers/payflow.rb", /Payflow\.configure/
    assert_file "config/initializers/payflow.rb", /default_provider/
    assert_file "config/initializers/payflow.rb", /asaas_api_key/
    assert_file "config/initializers/payflow.rb", /stripe_webhook_secret/
  end

  it "creates subscription migration" do
    run_generator

    assert_migration "db/migrate/create_payflow_subscriptions.rb" do |migration|
      assert_match(/create_table :payflow_subscriptions/, migration)
      assert_match(/t\.references :billable, polymorphic: true/, migration)
      assert_match(/add_index :payflow_subscriptions, :external_id, unique: true/, migration)
    end
  end

  it "creates invoice migration" do
    run_generator

    assert_migration "db/migrate/create_payflow_invoices.rb" do |migration|
      assert_match(/create_table :payflow_invoices/, migration)
      assert_match(/foreign_key: \{ to_table: :payflow_subscriptions \}/, migration)
    end
  end

  it "creates webhook event migration" do
    run_generator

    assert_migration "db/migrate/create_payflow_webhook_events.rb" do |migration|
      assert_match(/create_table :payflow_webhook_events/, migration)
      assert_match(/t\.json :payload/, migration)
    end
  end
end
