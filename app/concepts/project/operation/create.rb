require "trailblazer"

class Project
  class Create < Trailblazer::Operation
    include PermissionHelper

    step :check_permissions
    step Model( Project, :new )
    step Trailblazer::Operation::Contract::Build( constant: Project::Contract::Create )
    step Trailblazer::Operation::Contract::Validate()
    step :assign_client!

    def assign_client!(options, **)
      client = options[:client]
      project = options[:'contract.default'].sync
      project.client_id = client.id
      project.save
    end
  end
end