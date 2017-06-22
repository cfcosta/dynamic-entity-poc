module ViewDSL
  class Pane
    attr_reader :name, :fields

    def initialize(name, &block)
      @name = name
      @fields = []

      instance_exec(&block) if block
    end

    def field(name)
      fields << name
    end

    def pane(name, &block)
      field(self.class.new(name, &block))
    end
  end

  def field(name)
    fields << name
  end

  def pane(name, &block)
    field(Pane.new(name, &block))
  end

  def fields
    @fields ||= []
  end
end
