require 'rails_helper'

describe Projects::Api do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:client2) { FactoryBot.create(:client, name: 'Google') }
  let!(:project1) { FactoryBot.create(:project, name: 'Project1', status: 'started', client_id: client1.id) }
  let!(:valid_client_params) { { client: { name: 'New Client'} } }
  let!(:headers) { { 'Authorization' => JwtMock.header } }

  context 'POST /api/v1/projects/:id/clients' do
    it 'embeds a Client to an existing Project successfully' do
      expect{
        post("/api/v1/projects/#{project1.id}/clients", { params: valid_client_params, headers: headers })
      }.to change(Client, :count).by(1)
      expect(response.status).to eq(201)

      body = JSON.parse(response.body)
      expect(body['data']['type']).to eq('client')
      expect(body['data']['attributes']['name']).to eq('New Client')
    end
  end

  context 'POST /api/v1/projects/:id/clients' do
    it 'returns status 400 because Client params empty' do
      post "/api/v1/projects/#{project1.id}/clients", { params: { client: { name: ''} }, headers: headers }
      expect(response.status).to eq(400)
    end
  end

  context 'POST /api/v1/projects/:id/clients' do
    it 'returns status 404 because Project does not exist' do
      post "/api/v1/projects/#{1000}/clients", { params: { client: { name: 'Failed'} }, headers: headers }
      expect(response.status).to eq(404)
    end
  end

  context 'POST /api/v1/projects/clients' do
    it 'creates a new Client and a Project' do
      new_params = { client: { name: 'New Client' }, project: { name: 'New Project', status: 'started'} }
      expect {
        post "/api/v1/projects/clients", { params: new_params, headers: headers }
      }.to change(Project, :count).by(1)
      expect(response.status).to eq(201)
      body = JSON.parse(response.body)
      expect(body['data']['type']).to eq('client')
      expect(body['data']['attributes']['name']).to eq('New Client')
      expect(body['data']['relationships']['projects']).to_not be_nil

    end
  end

  context 'POST /api/v1/projects/clients' do
    it 'finds an existing Client and creates a Project for that Client' do
      new_params = { client: { name: client2.name }, project: { name: 'New Project', status: 'started'} }
      expect {
        post "/api/v1/projects/clients", { params: new_params, headers: headers }
      }.to change(Project, :count).by(1)
      expect(response.status).to eq(201)
    end
  end

  context 'POST /api/v1/projects/clients' do
    it 'returns status 400 because Client has empty params' do
      new_params = { client: { name: '' }, project: { name: 'New Project', status: 'started'} }
      post "/api/v1/projects/clients", { params: new_params, headers: headers }
      expect(response.status).to eq(400)
    end
  end

  context 'POST /api/v1/projects/clients' do
    it 'returns status 400 because Project has empty params' do
      new_params = { client: { name: 'Client' }, project: { name: '', status: '' } }
      post "/api/v1/projects/clients", { params: new_params, headers: headers }
      expect(response.status).to eq(400)
    end
  end
end