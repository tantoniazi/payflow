# frozen_string_literal: true

require "payflow/version"

module Payflow
  module Tasks
    extend Rake::DSL

    namespace :payflow do
      namespace :install do
        desc "Copy migrations from Payflow to host application"
        task migrations: :environment do
          engine = Payflow::Engine
          source = engine.root.join("db/migrate")
          destination = Rails.root.join("db/migrate")

          Dir.glob(source.join("*.rb")).each do |migration|
            target = destination.join(File.basename(migration))
            next if target.exist?

            FileUtils.cp(migration, target)
            puts "Copied #{File.basename(migration)}"
          end
        end
      end
    end
  end
end
