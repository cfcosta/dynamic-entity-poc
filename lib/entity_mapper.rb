require 'uri'

class EntityMapper
  def self.map(data)
    new(data).map
  end

  def initialize(data)
    @data = data.dup.symbolize_keys
  end

  def map
    feed = @data[:resourceTypePath]
      .match(/;([0-9a-zA-Z]+)\/rt/)[1]

    properties = @data
      .delete(:properties)
      .map { |(k,v)| [k.underscore.gsub(/\s/, '_'), v] }
      .to_h
      .symbolize_keys

    {
      id: @data.delete(:id),
      feed: feed,
      name: @data.delete(:name),
      path: @data.delete(:path),
      properties: properties,
      type_path: URI.unescape(@data.delete(:resourceTypePath))
    }.merge(@data)
  end
end
