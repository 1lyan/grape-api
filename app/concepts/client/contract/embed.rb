require 'reform/form/coercion'

module Client::Contract
  class Embed < Reform::Form
    feature Coercion

    property :id, type: Types::Integer
    property :name, type: Types::String

    validates :name, presence: true
  end
end