module Projects
  class Api < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    namespace :projects do

      route_param :id do
        params do
          requires :id, type: Integer, desc: 'Project Id'
        end

        resource :clients do
          desc 'Embeds a new Client to an existing Project'

          params do
            requires :name, type: String, desc: 'Client name'
          end

          post do
            project = Project.find_by(id: params[:id])

            error!(:not_found, 404) unless project

            service = Client::EmbedClient.new(Client::EmbedClientForm)

            result = service.call(Client.new, project, { name: params[:name] })

            error!(:bad_request, 400) if result.failure?

            ::ClientSerializer.new(result.value!).serialized_json
          end
        end
      end

      resource :clients do
        desc 'Creates a new Client and assigns a new Project to that Client'

        params do
          group :client, type: Hash do
            requires :name, type: String
          end
          group :project, type: Hash do
            requires :name, type: String
            requires :status, type: String
          end
        end

        post do
          client_service = Client::CreateClient.new(Client::CreateClientForm)
          client = Client.find_by(name: params[:client][:name])

          unless client
            client_result = client_service.call(Client.new, params[:client])
            error!(:bad_request, 400) if client_result.failure?

            client = client_result.value!
          end

          project_service = Project::CreateProject.new(Project::CreateProjectForm)
          project_result = project_service.call(client, Project.new, params[:project])

          error!(:bad_request, 400) if project_result.failure?

          ::ClientSerializer.new(client).serialized_json
        end
      end

    end

  end
end