class Entity
  attr_reader :metadata

  UnknownClass = Class.new(StandardError)
  UnmatchedData = Class.new(StandardError)

  @@entities = []

  def self.applicable?(_)
    raise NotImplementedError, 'Should be implemented by subclasses'
  end

  def self.register(klass)
    @@entities << klass
  end

  def self.registered_entities
    @@entities
  end

  def self.constantize(object)
    klass = const_get(object.klass)
    raise UnknownClass unless registered_entities.include?(klass)
    raise UnmatchedData unless klass.applicable?(object.metadata)

    klass.new(object.metadata)
  end

  def self.attribute(name)
    define_method(name) { @metadata[name] }
    define_method("#{name}=") { |value| @metadata[name] = value }
  end

  def initialize(metadata)
    @metadata = metadata
  end
end
