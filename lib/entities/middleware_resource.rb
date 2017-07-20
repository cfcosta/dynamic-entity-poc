require_relative '../entity'

class MiddlewareResource < Entity
  register self, weight: 0

  attribute :id
  attribute :name
  attribute :feed
  attribute :properties
  attribute :type_path
  attribute :path

  def self.applicable?(_)
    true
  end
end
