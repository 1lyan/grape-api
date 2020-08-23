require 'rails_helper'

RSpec.describe Client, type: :model do
  it 'creates a client' do
    client = FactoryBot.create(:client, name: 'RedLine')
    expect(client.present?).to eq(true)
  end
end
