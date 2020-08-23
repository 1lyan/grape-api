require 'rails_helper'

RSpec.describe Client::CreateProjectsForExistingClient do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:service) { Client::CreateProjectsForExistingClient.new(Project::CreateProjectForm) }
  let!(:new_project_params) { [{ name: 'Another Project', status: 'completed' }] }

  it 'creates projects for existing client' do
    result = service.call(client1, new_project_params)
    expect(result.success?).to eq(true)
    expect(result.value!).to eq(Project.all)
  end

  it 'fails the validation because params contain empty values' do
    result = service.call(client1, [{ name: '', status: ''}])
    expect(result.failure?).to eq(true)
  end

  it 'fails the validation because params contain no values' do
    result = service.call(client1, [])
    expect(result.failure?).to eq(true)
  end
end
