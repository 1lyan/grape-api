require 'rails_helper'

RSpec.describe Client::Create do

  it 'creates a client successfully' do
    result = Client::Create.(params: { name: 'New Client'})
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = Client::Create.(params: { name: ''})
    expect(result.failure?).to eq(true)
  end
end
