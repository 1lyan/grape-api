require "trailblazer"

class Client
  class Create < Trailblazer::Operation
    step Model( Client, :new )
    step Trailblazer::Operation::Contract::Build( constant: Client::Contract::Create )
    step Trailblazer::Operation::Contract::Validate()
    step Trailblazer::Operation::Contract::Persist()
  end
end