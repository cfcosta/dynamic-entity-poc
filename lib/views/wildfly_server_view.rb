require_relative '../view'
require_relative '../entities/wildfly_server'

class WildflyServerView < View
  pane :summary do
    pane :properties do
      field :name
      field :hostname
      field :feed
      field :bind_address
      field :product
      field :version
      field :metrics
    end
  end
end
