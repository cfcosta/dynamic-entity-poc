class MiddlewareEntity < ApplicationRecord
  validates :name, :klass, :metadata, presence: true
end
