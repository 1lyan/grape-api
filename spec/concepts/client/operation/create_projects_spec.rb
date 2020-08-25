require 'rails_helper'

RSpec.describe Client::CreateProjects do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:new_project_params) { [{ name: 'Another Project', status: 'completed' }] }

  it 'creates projects for existing client' do
    result = Client::CreateProjects.(params: new_project_params, client: client1)
    expect(result.success?).to eq(true)
    expect(result[:projects]).to eq(Project.all)
  end

  it 'fails the validation because params contain empty values' do
    result = Client::CreateProjects.(params: [{ name: '', status: ''}], client: client1)
    expect(result.failure?).to eq(true)
  end

  it 'fails the validation because params contain no values' do
    result = Client::CreateProjects.(params: [], client: client1)
    expect(result.failure?).to eq(true)
  end
end