require 'rails_helper'

RSpec.describe Client::EmbedClient do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:client2) { FactoryBot.create(:client, name: 'Google') }
  let!(:project1) { FactoryBot.create(:project, name: 'Project1', status: 'started', client_id: client1.id) }
  let!(:service) { Client::EmbedClient.new(Client::EmbedClientForm) }

  it 'embeds existing parent client for existing projects successfully' do
    result = service.call(client2, project1, {})
    expect(result.success?).to eq(true)
  end

  it 'creates a new client for existing projects successfully' do
    result = service.call(Client.new, project1, { name: 'New Client!'})
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = service.call(Client.new, project1, { name: ''})
    expect(result.failure?).to eq(true)
  end
end
