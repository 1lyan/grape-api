require 'rails_helper'

RSpec.describe Client::Embed do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:client2) { FactoryBot.create(:client, name: 'Google') }
  let!(:project1) { FactoryBot.create(:project, name: 'Project1', status: 'started', client_id: client1.id) }

  it 'embeds existing parent client for existing projects successfully' do
    result = Client::Embed.(client: client1, project: project1)
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = Client::Embed.(client: Client.new, project: Project.new)
    expect(result.failure?).to eq(true)
  end
end
