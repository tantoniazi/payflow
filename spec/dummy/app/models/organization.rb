# frozen_string_literal: true

class Organization < ApplicationRecord
  include Payflow::Billable
end
