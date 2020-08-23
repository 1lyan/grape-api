require 'rails_helper'

RSpec.describe Project::CreateProjectForm do
  let!(:client) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:project_params) {  { name: 'Project1', status: 'started' }  }
  let!(:project) { FactoryBot.build(:project, name: '', status: '', client_id: client.id) }
  let!(:invalid_params) { { name: 'Project2', status: 'closed' } }

  it 'validates form successfully' do
    form = Project::CreateProjectForm.new(project)
    expect(form.validate(project_params)).to eq(true)
  end

  it 'fails the validation for empty params' do
    form = Project::CreateProjectForm.new(project)
    expect(form.validate({})).to eq(false)
  end

  it 'fails validation for unknown status' do
    form = Project::CreateProjectForm.new(project)
    expect(form.validate(invalid_params)).to eq(false)
  end
end
