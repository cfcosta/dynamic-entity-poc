require_relative 'middleware_server'

# A specialized version of MiddlewareServer for servers running WildFly.
class WildflyServer < MiddlewareServer
  register self, weight: 100

  attribute :metrics

  # Returns if this entity is appliable for given metadata.
  def self.applicable?(data)
    data[:type_path].to_s.include?(URI.escape('WildFly Server'))
  end

  def bind_address
    properties['Bound Address']
  end

  def product
    properties['Product Name']
  end

  def version
    properties['Version']
  end
end
