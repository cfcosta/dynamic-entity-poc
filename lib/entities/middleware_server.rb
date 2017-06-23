require_relative '../entity'

class MiddlewareServer < Entity
  register self

  attribute :id
  attribute :name
  attribute :properties
  attribute :type_path

  def self.applicable?(data)
    data[:klass] == 'MiddlewareServer'
  end

  def feed
    @feed ||= type_path.match(/;([0-9a-zA-Z]+)\/rt/)[1]
  end
  alias hostname feed
end
