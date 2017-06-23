require 'spec_helper'
require 'entities/middleware_server'

describe MiddlewareServer do
  describe '.applicable?' do
    context 'is true for a middleware server' do
      Given(:metadata) { { klass: 'MiddlewareServer' } }

      Then { MiddlewareServer.applicable?(metadata) == true }
    end

    context 'is false for other entities' do
      Given(:metadata) { { klass: 'Datasource' } }

      Then { MiddlewareServer.applicable?(metadata) == false }
    end
  end

  describe '#feed' do
    Given(:type_path) { '/t;hawkular/f;37b3606f962e/rt;Platform_Operating%20System' }
    Given(:server) { MiddlewareServer.new(type_path: type_path) }

    Then { server.feed == '37b3606f962e' }
  end
end
