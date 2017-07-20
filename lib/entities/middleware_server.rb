require_dependency 'entities/middleware_resource'

class MiddlewareServer < MiddlewareResource
  register self, weight: 10

  def self.applicable?(_)
    false
  end
end
