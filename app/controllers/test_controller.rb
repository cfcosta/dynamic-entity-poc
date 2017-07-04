require 'hawkular/hawkular_client'
require_dependency 'entity'
require_dependency 'view_dsl'
require_dependency 'view'
require_dependency 'entities/middleware_server'
require_dependency 'entities/wildfly_server'
require_dependency 'views/wildfly_server_view'
require_dependency 'hawkular_connection'

class TestController < ApplicationController
  def index
    render json: { view: WildflyServerView.new(servers.first).as_json }
  end
end
