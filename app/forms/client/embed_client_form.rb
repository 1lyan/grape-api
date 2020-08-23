require 'reform/form/coercion'

class Client
  class EmbedClientForm < Reform::Form
    feature Coercion

    property :id, type: Types::Integer
    property :name, type: Types::String

    validates :name, presence: true
  end
end