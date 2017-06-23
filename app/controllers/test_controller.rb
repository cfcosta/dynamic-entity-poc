require 'hawkular/hawkular_client'
require_dependency 'entity'
require_dependency 'view_dsl'
require_dependency 'view'
require_dependency 'entities/middleware_server'
require_dependency 'entities/wildfly_server'
require_dependency 'views/wildfly_server_view'

class TestController < ApplicationController
  def index
    client = Hawkular::Client.new(
      entrypoint: 'http://localhost:8080',
      credentials: { username: 'jdoe', password: 'password' },
      options: { tenant: 'hawkular' }
    )

    resources = client.inventory.list_feeds.map do |feed|
      metrics = client.inventory.list_metric_types(feed).map do |resource|
        resource.instance_variable_get(:@_hash).symbolize_keys
      end

      client.inventory.list_resources_for_feed(feed, true).map do |resource|
        resource
          .instance_variable_get(:@_hash)
          .symbolize_keys
          .tap { |r| r[:metrics] = metrics }
      end
    end.flatten

    def feed(r)
      r[:resourceTypePath].match(/;([0-9a-zA-Z]+)\/rt/)[1]
    end

    resources.group_by { |r| feed(r) }.each do |_, resources|
      properties = resources.inject(Hash.new({})) { |h, r| h.merge(r[:properties]) }
      resources.each { |r| r[:properties] = properties }
    end

    servers = resources.map do |r|
      WildflyServer.new(
        id: r[:id],
        name: r[:name],
        properties: r[:properties],
        type_path: r[:resourceTypePath],
        metrics: r[:metrics]
      )
    end

    render json: { view: WildflyServerView.new(servers.first).as_json }
  end
end
