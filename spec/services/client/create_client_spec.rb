require 'rails_helper'

RSpec.describe Client::CreateClient do
  let!(:service) { Client::CreateClient.new(Client::CreateClientForm) }

  it 'creates a client successfully' do
    result = service.call(Client.new, { name: 'New Client'})
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = service.call(Client.new, { name: ''})
    expect(result.failure?).to eq(true)
  end
end
