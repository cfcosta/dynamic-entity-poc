require 'spec_helper'
require 'entities/middleware_server'
require 'renderers/middleware_server_renderer'

RSpec.describe MiddlewareServerRenderer do
  Given(:server) { MiddlewareServer.new(name: 'MockServer') }
  Given(:renderer) { MiddlewareServerRenderer.new(server) }

  describe '#to_json' do
    Then { renderer.to_json == { name: 'MockServer' }.to_json }
  end
end
