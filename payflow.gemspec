# frozen_string_literal: true

require_relative "lib/payflow/version"

Gem::Specification.new do |spec|
  spec.name          = "payflow"
  spec.version       = Payflow::VERSION
  spec.authors       = ["Seu Nome"]
  spec.email         = ["seu@email.com"]

  spec.summary       = "Unified multi-provider billing system for Rails (Asaas, Stripe, Mercado Pago, Pagar.me)"
  spec.description   = "A production-ready billing abstraction layer for SaaS applications in Ruby on Rails."
  spec.homepage      = "https://github.com/seuuser/payflow"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir["lib/**/*", "app/**/*", "README.md", "LICENSE"]

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "sidekiq", ">= 6.0"
  spec.add_dependency "activejob"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "sqlite3"
end
