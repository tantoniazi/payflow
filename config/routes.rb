# frozen_string_literal: true

Payflow::Engine.routes.draw do
  post "webhooks/asaas", to: "webhooks#asaas"
end
