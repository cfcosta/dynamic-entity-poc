require_relative '../entity'

class MiddlewareServer < Entity
  register self

  attribute :name

  def self.applicable?(data)
    data[:klass] == 'MiddlewareServer'
  end
end
