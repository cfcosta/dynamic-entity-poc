require_dependency 'entities/middleware_resource'

class JavaRuntime < MiddlewareResource
  register self

  def self.applicable?(metadata)
    metadata[:type_path].include?('Runtime MBean')
  end
end
