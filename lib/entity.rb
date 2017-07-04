class Entity
  attr_reader :metadata

  NoMatchedEntity = Class.new(StandardError)

  @@entities = []

  def self.applicable?(_)
    raise NotImplementedError, 'Should be implemented by subclasses'
  end

  def self.register(klass, weight: 0)
    @@entities << [klass, weight]
  end

  def self.unregister(klass)
    @@entities -= @@entities.select { |e| e[0] == klass }
  end

  def self.registered_entities
    @@entities
      .sort {|a,b| b[1] <=> a[1] }
      .uniq
      .map(&:first)
  end

  def self.constantize(metadata)
    klass = registered_entities.find { |e| e.applicable?(metadata) }
    raise NoMatchedEntity unless klass

    klass.new(metadata)
  end

  def self.attribute(name)
    define_method(name) { |&block| @metadata.fetch(name, &block) }
    define_method("#{name}=") { |value| @metadata[name] = value }
  end

  def initialize(metadata)
    @metadata = metadata
  end
end
