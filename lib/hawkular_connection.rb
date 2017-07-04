require 'hawkularclient'

class HawkularConnection
  def client(client_class = Hawkular::Client)
    @client ||= client_class.new(
      entrypoint: 'http://localhost:8080',
      credentials: { username: 'jdoe', password: 'password' },
      options: { tenant: 'hawkular' }
    )
  end

  def get_all_resources
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

    resources.group_by { |r| feed(r) }.each do |_, resources|
      properties = resources.inject(Hash.new({})) { |h, r| h.merge(r[:properties]) }
      resources.each { |r| r[:properties] = properties }
    end

    resources.map do |r|
      Entity.constantize(
        id: r[:id],
        name: r[:name],
        properties: r[:properties],
        type_path: r[:resourceTypePath],
        metrics: r[:metrics]
      )
    end
  end

  def feed(r)
    r[:resourceTypePath].match(/;([0-9a-zA-Z]+)\/rt/)[1]
  end
end
