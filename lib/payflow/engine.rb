# frozen_string_literal: true

module Payflow
  class Engine < ::Rails::Engine
    isolate_namespace Payflow

    config.generators do |generator|
      generator.test_framework :rspec
    end

    initializer "payflow.migrations" do |app|
      unless app.root.to_s.match?(root.to_s)
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end

    rake_tasks do
      load root.join("lib/tasks/payflow_tasks.rake")
    end
  end
end
