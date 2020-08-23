require 'dry/monads/result'

class Project
  class CreateProject
    include Dry::Monads::Result::Mixin

    attr_reader :project_form_class

    def initialize(project_form_class)
      @project_form_class = project_form_class
    end

    def call(client, project, project_params)
      form = project_form_class.new(project)

      if form.validate(project_params)
        project = create_project!(client, form)

        Success.new(project)
      else
        Failure.new(form)
      end
    rescue => e
      Failure.new(e)
    end

    private

    def create_project!(client, form)
      project = form.sync
      project.client_id = client.id
      project.save!
      project
    end
  end
end