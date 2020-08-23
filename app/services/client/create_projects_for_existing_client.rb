require 'dry/monads/result'

class Client
  class CreateProjectsForExistingClient
    include Dry::Monads::Result::Mixin

    attr_reader :project_form_class

    def initialize(project_form_class)
      @project_form_class = project_form_class
    end

    def call(client, project_params)

      return Failure.new(StandardError.new('Projects params empty')) if project_params.size.zero?

      projects = []
      project_params.each do |params_for_project|
        service = Project::CreateProject.new(Project::CreateProjectForm)
        result = service.call(client, Project.new, params_for_project)

        if result.failure?
          return result
        end
        projects << result.value!
      end

      Success.new(projects)
    end
  end
end