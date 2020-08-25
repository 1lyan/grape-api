require "trailblazer"

class Client
  class Embed < Trailblazer::Operation
    step :validate
    step :embed_client!

    def validate(options, **)
      options[:client].valid? && options[:project].valid?
    end

    def embed_client!(options, **)
      client = options[:client]
      project = options[:project]
      project.update(client_id: client.id)
    end
  end
end