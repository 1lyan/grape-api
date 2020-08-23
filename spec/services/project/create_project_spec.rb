require 'rails_helper'

RSpec.describe Project::CreateProject do
  let!(:client1) { FactoryBot.create(:client, name: 'RedLine') }
  let!(:client2) { FactoryBot.create(:client, name: 'Google') }
  let!(:project1) { FactoryBot.create(:project, name: 'Project1', status: 'started', client_id: client1.id) }
  let!(:service) { Project::CreateProject.new(Project::CreateProjectForm) }
  let!(:new_project_params) { { name: 'Another Project', status: 'completed' } }

  it 'creates projects for existing client' do
    result = service.call(client1, Project.new, new_project_params)
    expect(result.success?).to eq(true)
  end

  it 'fails the validation' do
    result = service.call(client1, Project.new, { name: '', status: ''})
    expect(result.failure?).to eq(true)
  end
end
