require_dependency 'entities/middleware_resource'

class OperatingSystem < MiddlewareResource
  register self

  def self.applicable?(metadata)
    metadata[:type_path].include?('Platform_Operating System')
  end
end
