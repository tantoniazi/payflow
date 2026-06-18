# frozen_string_literal: true

module Payflow
  module Providers
    module Asaas
      class Customer
        def initialize(client)
          @client = client
        end

        def create(attrs)
          { id: "cus_asaas_stub_#{SecureRandom.hex(4)}", provider: :asaas, email: attrs[:email], name: attrs[:name] }
        end
      end
    end
  end
end
