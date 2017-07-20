require_relative './entity_mapper'
require_relative './entity'
require_relative './entities/wildfly_server'

class HawkularResourceCollection
  attr_reader :data

  def initialize(resources)
    @data = resources.map { |r| r.instance_variable_get(:@_hash) }
  end

  def entities
    @entities ||= data.map { |d| Entity.constantize(EntityMapper.map(d)) }
  end

  def prepare
    servers = entities.select { |x| x.is_a? MiddlewareServer }
    resources = entities - servers

    servers.each do |server|
      server.properties.reverse_merge!(resources.inject({}) { |accum,el| accum.merge(el.properties)})
    end

    entities
  end
end
