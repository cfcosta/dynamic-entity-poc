require 'multi_json'

RendererNotFound = Class.new(NameError)

class Renderer
  attr_reader :target

  def self.for(klass)
    const_get("#{klass}Renderer")
  rescue NameError => e
    fail RendererNotFound, e
  end

  def initialize(target)
    @target = target
  end

  def to_json
    raise NotImplementedError, 'should be overriden by subclass'
  end
end
