# frozen_string_literal: true

Rails.application.routes.draw do
  mount Payflow::Engine => "/payflow"
end
