require 'spec_helper'
require 'middleware_server'

describe MiddlewareServer do
  describe '.applicable?' do
    context 'is true if server is online' do
      Given(:metadata) { { server_status: 'online' } }
      Then { MiddlewareServer.applicable?(metadata) == true }
    end

    context 'is false if server is offline' do
      Given(:metadata) { { server_status: 'offline' } }
      Then { MiddlewareServer.applicable?(metadata) == false }
    end
  end
end
