require_dependency 'entities/middleware_resource'

class HawkularAgent < MiddlewareResource
  register self

  def self.applicable?(metadata)
    metadata[:type_path].include?('Hawkular WildFly Agent')
  end
end
