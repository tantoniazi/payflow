# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module Payflow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Creates Payflow initializer and database migrations"

      def create_initializer
        template "initializer.rb", "config/initializers/payflow.rb"
      end

      def create_migrations
        migration_template "migration_subscription.rb", "db/migrate/create_payflow_subscriptions.rb"
        migration_template "migration_invoice.rb", "db/migrate/create_payflow_invoices.rb"
        migration_template "migration_webhook_event.rb", "db/migrate/create_payflow_webhook_events.rb"
      end

      def show_readme
        return unless behavior == :invoke

        say "\nPayflow installed successfully!", :green
        say "  Run `rails db:migrate` to apply the migrations."
        say ""
        say "Note: Payflow::Engine also appends engine migrations when the gem is loaded."
        say "Use either this generator OR `rails payflow:install:migrations` — not both."
      end

      def self.next_migration_number(_dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
