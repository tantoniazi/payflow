# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "payflow"

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

desc "Run all specs"
task default: :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

namespace :spec do
  desc "Prepare test database"
  task prepare: :environment do
    ActiveRecord::Tasks::DatabaseTasks.env = "test"
    ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("spec/dummy/db", __dir__)
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = [
      File.expand_path("spec/dummy/db/migrate", __dir__),
      File.expand_path("db/migrate", __dir__)
    ]
    ActiveRecord::Tasks::DatabaseTasks.create_current
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end
end

task spec: "spec:prepare"

task :environment do
  require File.expand_path("spec/dummy/config/environment", __dir__)
end
