require 'spec_helper'
require 'entities/wildfly_server'

RSpec.describe WildflyServer do
  describe '.applicable?' do
    Given(:not_middleware_server) { { klass: 'Datasource' } }
    Given(:not_wildfly_server) do
      { klass: 'MiddlewareServer', type_path: 'fake' }
    end
    Given(:wildfly_server) do
      {
        type_path: '/t;hawkular/f;c5be0849abea/rt;WildFly%20Server'
      }
    end

    Then { WildflyServer.applicable?(not_middleware_server) == false }
    Then { WildflyServer.applicable?(not_wildfly_server) == false }
    Then { WildflyServer.applicable?(wildfly_server) == true }
  end
end
