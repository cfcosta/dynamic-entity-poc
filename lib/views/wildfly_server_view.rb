require_dependency 'views/middleware_resource_view'
require_dependency 'entities/wildfly_server'

class WildflyServerView < MiddlewareResourceView
  pane :summary do
    field :bind_address
    field :product
    field :version
  end

  field :properties
end
