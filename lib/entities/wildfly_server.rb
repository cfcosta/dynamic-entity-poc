require_dependency 'entities/middleware_server'

# A specialized version of MiddlewareServer for servers running WildFly.
class WildflyServer < MiddlewareServer
  register self, weight: 100

  attribute :metrics
  attribute :bind_address
  attribute :product
  attribute :version

  # Returns if this entity is appliable for given metadata.
  def self.applicable?(data)
    data[:type_path].to_s.include?('WildFly Server')
  end

  def bind_address
    properties[:bound_address]
  end

  def product
    properties[:product_name]
  end

  def version
    properties[:version]
  end
end
