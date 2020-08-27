module Clients
  class Api < Grape::API
    version 'v1', using: :path
    format :txt
    prefix :api

    include Grape::Kaminari

    helpers do
      def execute_request(client, operation, serializer)
        result = operation.(params: params[:projects], client: client, token: token)

        error!(:bad_request, 400) if result.failure?

        projects = result[:projects]
        serializer.new(projects, { is_collection: true }).serialized_json
      end

      def token
        request.headers['Authorization'].to_s.split(' ').last
      end

      def token_ok?
        payload = JwtMock.decode_token(token)
        info = payload[0]

        return true if info['create']

        false
      rescue => _
        false
      end
    end

    namespace :clients do
      route_param :id do
        params do
          requires :id, type: Integer, desc: 'Client Id'
        end

        resource :client do
          params do
            optional :project_id, type: Integer, desc: 'Project Id'
            optional :project_status, type: String, desc: 'Project Status'
            optional :project_created_at, type: Integer, desc: 'Project creation timestamp'
          end

          get do
            return status(403) unless token_ok?

            client = Client.find_by(id: params[:id])
            error!(:not_found, 404) unless client

            if params[:project_id].present?
              project = client.projects.find_by(id: params[:project_id])
              error!(:not_found, 404) unless project
              ::ProjectSerializer.new(project).serialized_json
            elsif params[:project_status].present?
              projects = client.projects.where(status: 'started')

              projects = Kaminari.paginate_array(projects.to_a, limit: params[:limit], offset: params[:ofset], total_count: Project.count)
              ::ProjectSerializer.new(projects, { is_collection: true }).serialized_json
            elsif params[:project_created_at].present?
              projects = client.projects.where('created_at > ?', params[:project_created_at].to_i)

              projects = Kaminari.paginate_array(projects.to_a, limit: params[:limit], offset: params[:ofset], total_count: Project.count)
              ::ProjectSerializer.new(projects, { is_collection: true }).serialized_json
            else
              ::ClientSerializer.new(client).serialized_json
            end
          end
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
          result = Client::Create.(params: params[:client], token: token)
          error!(:bad_request, 400) if result.failure?
          execute_request(result[:model], Client::CreateProjects, ::ProjectSerializer)
        end

      end
    end
  end
end
