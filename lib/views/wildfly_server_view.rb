require_dependency 'views/middleware_resource_view'
require_dependency 'entities/wildfly_server'

class WildflyServerView < MiddlewareResourceView
  pane :summary do
    field :bind_address
    field :product
    field :version
    field :server_state
  end

  field :properties

  def server_state
    entity.properties[:server_state]
  end
end
