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

  context 'GET /api/v1/clients/:id/client' do
    it 'finds an existing Client and returns them' do
      get "/api/v1/clients/#{client1.id}/client", { headers: headers }
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body['data']['type']).to eq('client')
      expect(body['data']['attributes']['name']).to eq(client1.name)
    end
  end

  context 'GET /api/v1/clients/:id/client?project_id=:project_id' do
    it 'finds an existing Client and then finds a project for that client and returns that project' do
      project = FactoryBot.create(:project, name: 'Redline Project', status: 'started', client_id: client1.id)

      get "/api/v1/clients/#{client1.id}/client?project_id=#{project.id}", { headers: headers }
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body['data']['type']).to eq('project')
      expect(body['data']['attributes']['name']).to eq(project.name)
      expect(body['data']['attributes']['status']).to eq(project.status)
    end
  end

  context 'GET /api/v1/clients/:id/client?project_status=:project_status' do
    it 'finds an existing Client and then returns a collection of projects by status' do
      project = FactoryBot.create(:project, name: 'Redline Project', status: 'started', client_id: client1.id)

      get "/api/v1/clients/#{client1.id}/client?project_status=#{project.status}", { headers: headers }
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body['data'][0]['type']).to eq('project')
      expect(body['data'][0]['attributes']['name']).to eq(project.name)
      expect(body['data'][0]['attributes']['status']).to eq(project.status)
    end
  end

  context 'GET /api/v1/clients/:id/client?project_created_at=:project_created_at' do
    it 'finds an existing Client and then returns a collection of projects by creation time' do
      project = FactoryBot.create(:project, name: 'Redline Project', status: 'started', client_id: client1.id)
      timestamp = Time.current.to_date.to_time.to_i

      get "/api/v1/clients/#{client1.id}/client?project_created_at=#{timestamp}", { headers: headers }
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body['data'][0]['type']).to eq('project')
      expect(body['data'][0]['attributes']['name']).to eq(project.name)
      expect(body['data'][0]['attributes']['status']).to eq(project.status)
    end
  end

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