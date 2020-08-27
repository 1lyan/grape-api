module Projects
  class Api < Grape::API
    version 'v1', using: :path
    format :txt
    prefix :api

    namespace :projects do

      helpers do
        def token
          request.headers['Authorization'].to_s.split(' ').last
        end
      end

      route_param :id do
        params do
          requires :id, type: Integer, desc: 'Project Id'
        end

        resource :clients do
          desc 'Embeds a new Client to an existing Project'

          params do
            group :client, type: Hash do
              requires :name, type: String, desc: 'Client name'
            end
          end

          post do
            project = Project.find_by(id: params[:id])

            error!(:not_found, 404) unless project

            result = Client::Create.(params: params[:client], token: token)

            error!(:bad_request, 400) if result.failure?

            ::ClientSerializer.new(result[:model]).serialized_json
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
          client = Client.find_by(name: params[:client][:name])

          unless client
            client_result = Client::Create.(params: params[:client], token: token)
            error!(:bad_request, 400) if client_result.failure?

            client = client_result[:model]
          end

          project_result = Project::Create.(params: params[:project], client: client, token: token)

          error!(:bad_request, 400) if project_result.failure?

          ::ClientSerializer.new(client).serialized_json
        end
      end

    end

  end
end