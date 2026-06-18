# frozen_string_literal: true

Payflow::Engine.routes.draw do
  namespace :webhooks do
    post "/asaas", to: "asaas#receive"
    post "/stripe", to: "stripe#receive"
  end
end
