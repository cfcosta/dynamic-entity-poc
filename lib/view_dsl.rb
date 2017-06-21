module ViewDSL
  class Pane
    attr_reader :name, :fields

    def initialize(name)
      @name = name
      @fields = []
    end

    def pane(name, &block)
      new_pane = self.class.new(name).tap { |p| p.instance_exec(&block) }
      fields << new_pane
    end

    def field(name)
      fields << name
    end
  end

  def pane(name, &block)
    fields << Pane.new(name).tap { |p| p.instance_exec(&block) }
  end

  def field(name)
    fields << name
  end

  def fields
    @fields ||= []
  end
end
