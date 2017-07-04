module ViewDSL
  class Pane
    attr_reader :name, :fields

    def initialize(name, &block)
      @name = name
      @fields = []

      instance_exec(&block) if block
    end

    def field(name, accessor = nil)
      accessor_name = (accessor || name.to_s.split('.').last).to_sym
      fields << [name, accessor_name]
    end

    def pane(name, &block)
      field(self.class.new(name, &block), name)
    end
  end

  def field(name, accessor = nil)
    accessor_name = (accessor || name.to_s.split('.').last).to_sym
    fields << [name, accessor_name]
  end

  def pane(name, &block)
    field(Pane.new(name, &block))
  end

  def fields
    @fields ||= []
  end
end
