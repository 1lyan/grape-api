require 'dry/monads/result'

class Client
  class EmbedClient
    include Dry::Monads::Result::Mixin

    attr_reader :embed_client_form_class

    def initialize(embed_client_form_class)
      @embed_client_form_class = embed_client_form_class
    end

    def call(client, project, client_params)
      form = embed_client_form_class.new(client)

      if form.validate(client_params)
        client = embed_client!(project, form)

        Success.new(client)
      else
        Failure.new(form)
      end
    rescue => e
      Failure.new(e)
    end

    private

    def embed_client!(project, form)
      client = form.sync
      client.save!
      project.client_id = client.id
      project.save
      client
    end
  end
end