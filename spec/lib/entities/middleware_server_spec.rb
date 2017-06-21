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
end
