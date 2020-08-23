class ClientSerializer
  include FastJsonapi::ObjectSerializer
  set_type :client
  attributes :name
  has_many :projects, lazy_load_data: false
end