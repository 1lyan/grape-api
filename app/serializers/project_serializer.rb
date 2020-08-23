class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  set_type :project
  set_id :client_id
  attributes :name, :status
  belongs_to :client, record_type: :client
end