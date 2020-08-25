module Permissions
  class Api < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    resource :permissions do
      desc 'Embeds a new Client to an existing Project'

      params do
        requires :token, type: String, desc: 'JWT Token'
      end

      post do
        payload = JwtMock.decode_token(params[:token])
        info = payload[0]

        return status(200) if info['create']

        status(403)
      rescue => _
        status(403)
      end
    end

  end
end