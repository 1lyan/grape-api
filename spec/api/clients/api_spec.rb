require 'rails_helper'

describe Clients::Api do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:project_collection_params) do
    [{ name: 'Tesla', status: 'completed' }, { name: 'SpaceX', status: 'started' }]
  end

  let!(:invalid_project_collection_params) do
    [{ name: '', status: '' }, { name: 'AAA', status: 'started' }]
  end

  let!(:new_client_params) { { name: 'HBO' } }

  let!(:headers) { { 'Authorization' => JwtMock.header } }

  context 'POST /api/v1/clients/:id/projects' do
    it 'finds an existing Client and creates a collection of Projects for that Client' do
      expect {
        post "/api/v1/clients/#{client1.id}/projects", { params: { projects: project_collection_params }, headers: headers }
      }.to change(Project, :count).by(2)
      expect(response.status).to eq(201)

      body = JSON.parse(response.body)
      expect(body['data'][0]['type']).to eq('project')
      expect(body['data'][0]['attributes']['name']).to eq('Tesla')
      expect(body['data'][0]['attributes']['status']).to eq('completed')
      expect(body['data'].size).to eq(project_collection_params.size)
    end
  end

  context 'POST /api/v1/clients/:id/projects' do
    it 'returns 400 status because Project params are invalid' do
      expect{
        post "/api/v1/clients/#{client1.id}/projects", { params: { projects: invalid_project_collection_params }, headers: headers }
      }.to change(Project, :count).by(0)
      expect(response.status).to eq(400)
    end
  end

  context 'POST /api/v1/clients/:id/projects' do
    it 'returns 404 status because Client does not exist' do
      expect{
        post "/api/v1/clients/#{1000}/projects", { params: { projects: project_collection_params }, headers: headers }
      }.to change(Project, :count).by(0)
      expect(response.status).to eq(404)
    end
  end

  context 'POST /api/v1/clients/clients' do
    it 'creates a new Client and creates a collection of Projects for that Client' do
      expect{
        post "/api/v1/clients/clients", { params: { client: new_client_params, projects: project_collection_params }, headers: headers }
      }.to change(Project, :count).by(2)
      expect(response.status).to eq(201)
    end
  end

  context 'POST /api/v1/clients/clients' do
    it 'returns 400 status because Client params are empty' do
      expect{
        post "/api/v1/clients/clients", { params: { client: {} }, headers: headers }
      }.to change(Project, :count).by(0)
      expect(response.status).to eq(400)
    end
  end

  context 'POST /api/v1/clients/clients' do
    it 'returns 400 status because Project params are empty' do
      expect{
        post "/api/v1/clients/clients", { params: { client: new_client_params, projects: [] }, headers: headers }
      }.to change(Project, :count).by(0)
      expect(response.status).to eq(400)
    end
  end

end