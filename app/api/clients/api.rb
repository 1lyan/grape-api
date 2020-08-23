module Clients
  class Api < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    namespace :clients do
      route_param :id do
        params do
          requires :id, type: Integer, desc: 'Client Id'
        end

        resource :projects do
          desc 'Creates a collection of Projects for an existing Client'

          params do
            group :projects, type: Array do
              requires :name, type: String
              requires :status, type: String
            end
          end

          post do
            Rails.logger.info(params)
            Rails.logger.info(request)
            # debugger
            client = Client.find_by(id: params[:id])
            # debugger
            error!(:not_found, 404) unless client

            service = Client::CreateProjectsForExistingClient.new(Project::CreateProjectForm)

            result = service.call(client, params[:projects])

            error!(:bad_request, 400) if result.failure?

            projects = result.value!
            ::ProjectSerializer.new(projects, { is_collection: true }).serialized_json
          end
        end
      end

      resource :clients do
        desc 'Creates a collection of Projects for a new Client'

        params do
          group :client, type: Hash do
            requires :name, type: String
          end

          group :projects, type: Array do
            requires :name, type: String
            requires :status, type: String
          end
        end

        post do
          Rails.logger.info(request.headers)

          client_service = Client::CreateClient.new(Client::CreateClientForm)
          client_result = client_service.call(Client.new, params[:client])
          error!(:bad_request, 400) if client_result.failure?

          client = client_result.value!
          project_service = Client::CreateProjectsForExistingClient.new(Project::CreateProjectForm)
          project_result = project_service.call(client, params[:projects])

          error!(:bad_request, 400) if project_result.failure?

          projects = project_result.value!
          ::ProjectSerializer.new(projects, { is_collection: true }).serialized_json
        end


      end
    end
  end
end