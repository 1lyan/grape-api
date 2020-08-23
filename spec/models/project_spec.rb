require 'rails_helper'

RSpec.describe Project, type: :model do
  let!(:client) { FactoryBot.create(:client, name: 'RedLine') }

  it 'creates a projects and binds it to a client' do
    project = FactoryBot.create(:project, name: 'Project1', status: 'started', client_id: client.id)
    expect(project.client).to eq(client)
  end

end
