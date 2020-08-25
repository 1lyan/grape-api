require 'rails_helper'

RSpec.describe Project::Create do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:new_project_params) { { name: 'Another Project', status: 'completed' } }

  it 'creates projects for existing client' do
    result = Project::Create.(params: new_project_params, client: client1)
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = Project::Create.(params: { name: '', status: ''}, client: client1)
    expect(result.failure?).to eq(true)
  end
end
