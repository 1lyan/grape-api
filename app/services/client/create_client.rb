require 'dry/monads/result'

class Client
  class CreateClient
    include Dry::Monads::Result::Mixin

    attr_reader :form_class

    def initialize(form_class)
      @form_class = form_class
    end

    def call(client, client_params)
      form = form_class.new(client)

      if form.validate(client_params)
        client = create_client!(form)

        Success.new(client)
      else
        Failure.new(form)
      end
    rescue => e
      Failure.new(e)
    end

    private

    def create_client!(form)
      client = form.sync
      client.save!
      client
    end
  end
end