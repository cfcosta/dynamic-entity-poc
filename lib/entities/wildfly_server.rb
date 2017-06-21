require_relative 'middleware_server'

# A specialized version of MiddlewareServer for servers running WildFly.
class WildflyServer < MiddlewareServer
  register self

  # Returns if this entity is appliable for given metadata.
  def self.applicable?(data)
    data[:klass] == 'MiddlewareServer' &&
      data[:resource_type_path].include?(URI.escape('WildFly Server'))
  end
end
