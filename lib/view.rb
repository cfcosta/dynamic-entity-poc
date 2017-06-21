require 'multi_json'
require_relative 'view_dsl'

class View
  attr_reader :data

  extend ViewDSL

  def initialize(data)
    @data = data
  end

  def render_json
    result = self.class.fields.inject({}) { |h, f| h.merge render(f) }

    MultiJson.dump(result)
  end

  def render_schema
  end

  private def render(field)
    case field
    when Symbol
      { field => data.public_send(field) }
    when ViewDSL::Pane
      rendered = field.fields
        .inject({}) { |h, f| h.merge(render(f)) }

      { field.name => rendered }
    end
  end
end
