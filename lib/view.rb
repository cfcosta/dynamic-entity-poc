require 'multi_json'
require_relative 'view_dsl'

class View
  attr_reader :data

  extend ViewDSL

  def initialize(data)
    @data = data
  end

  def as_json(*args)
    self.class.fields.inject({}) { |h, f| h.merge render(f) }
  end

  def render_json
    MultiJson.dump(as_json)
  end

  def render_schema
  end

  private def render(field)
    case field
    when Symbol
      { field.to_s.camelize(:lower).to_sym => data.public_send(field) }
    when ViewDSL::Pane
      rendered = field.fields
        .inject({}) { |h, f| h.merge(render(f)) }

      { field.name.to_s.camelize(:lower).to_sym => rendered }
    end
  end
end
