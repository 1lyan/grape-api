require 'reform/form/coercion'

class Project
  class CreateProjectForm < Reform::Form
    feature Coercion

    property :id, type: Types::Integer
    property :name, type: Types::String
    property :status, type: Types::String

    validates :name, :status, presence: true
    validates :status, inclusion: { in: Project::STATUSES.keys.map { |status| status.to_s } }
  end
end