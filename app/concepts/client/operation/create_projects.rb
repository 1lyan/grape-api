require "trailblazer"

class Client
  class CreateProjects < Trailblazer::Operation
    include PermissionHelper

    step :check_permissions
    step :validate_params
    step :save_projects!

    def validate_params(options, **)
      return false if options[:params].size.zero?
      true
    end

    def save_projects!(options, **)

      projects = []
      options[:params].each do |params_for_project|
        result = Project::Create.(params: params_for_project, client: options[:client], token: options[:token])

        if result.failure?
          return false
        end
        projects << result[:model]
      end

      options[:projects] = projects
    end

  end
end