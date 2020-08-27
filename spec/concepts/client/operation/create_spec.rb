require 'rails_helper'

RSpec.describe Client::Create do

  let!(:valid_params) { { name: 'New Client'} }
  let!(:invalid_params) { { name: ''} }
  let!(:token) { JwtMock.token }

  it 'creates a client successfully' do
    result = Client::Create.(params: valid_params, token: token)
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = Client::Create.(params: invalid_params, token: token)
    expect(result.failure?).to eq(true)
  end
end
