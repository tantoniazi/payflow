# frozen_string_literal: true

require_relative "lib/payflow/version"

Gem::Specification.new do |spec|
  spec.name          = "payflow"
  spec.version       = Payflow::VERSION
  spec.authors       = ["Conexus Systems"]
  spec.email         = ["dev@conexus-systems.com.br"]

  spec.summary       = "Unified billing engine for Rails (Asaas, Stripe)"
  spec.description   = "A mountable Rails engine for subscription billing with Asaas and Stripe providers."
  spec.homepage      = "https://github.com/tantoniazi/payflow"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    tracked = `git ls-files -z 2>/dev/null`.split("\x0")
    if tracked.empty?
      Dir["{lib,app,config,db/migrate}/**/*", "LICENSE", "README.md"].select { |f| File.file?(f) }
    else
      tracked.select do |f|
        File.file?(f) &&
          (f.start_with?("lib/", "app/", "config/", "db/migrate/") ||
           %w[README.md LICENSE].include?(f))
      end
    end
  end

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "sidekiq", ">= 6.0"
  spec.add_dependency "activejob"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "sqlite3"
end
