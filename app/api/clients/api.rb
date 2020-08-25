module Clients
  class Api < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def execute_request(client, operation, serializer)
        result = operation.(params: params[:projects], client: client)

        error!(:bad_request, 400) if result.failure?

        projects = result[:projects]
        serializer.new(projects, { is_collection: true }).serialized_json
      end

    end

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
            client = Client.find_by(id: params[:id])
            error!(:not_found, 404) unless client
            execute_request(client, Client::CreateProjects, ::ProjectSerializer)
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
          result = Client::Create.(params: params[:client])
          error!(:bad_request, 400) if result.failure?
          execute_request(result[:model], Client::CreateProjects, ::ProjectSerializer)
        end

      end
    end
  end
end
