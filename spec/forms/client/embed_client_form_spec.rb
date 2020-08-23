require 'rails_helper'

RSpec.describe Client::EmbedClientForm do
  let!(:valid_client) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:invalid_client) { FactoryBot.build(:client, id: nil, name: '') }

  it 'validates form successfully' do
    form = Client::EmbedClientForm.new(valid_client)
    expect(form.validate({})).to eq(true)
  end

  it 'fails the validation' do
    form = Client::EmbedClientForm.new(invalid_client)
    expect(form.validate({})).to eq(false)
  end
end
