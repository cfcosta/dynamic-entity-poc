require 'multi_json'
require_relative 'view_dsl'

ViewNotFound = Class.new(NameError)

class View
  attr_reader :data

  extend ViewDSL

  def self.for(klass)
    const_get("#{klass}View")
  rescue NameError => e
    fail ViewNotFound, e
  end

  def initialize(data)
    @data = data
  end

  def as_json(*)
    superclass = self.class.superclass

    data = if superclass.is_a?(ViewDSL)
             superclass.new(@data).as_json
           else
             {}
           end

    self.class.fields
      .inject(data) { |h, f| h.deep_merge render(f) }
  end

  def render_json
    MultiJson.dump(as_json)
  end

  def render_schema
    raise NotImplementedError
  end

  private def render(row)
    field, alias_name = row

    case field
    when Symbol
      { normalize(alias_name) => data.public_send(alias_name) }
    when ViewDSL::Pane
      rendered = field.fields
        .inject({}) { |h, f| h.deep_merge(render(f)) }

      { normalize(field.name) => rendered }
    end
  end

  private def normalize(name)
    name.to_s.camelize(:lower).to_sym
  end
end
