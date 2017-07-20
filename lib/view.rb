require 'multi_json'
require_relative 'view_dsl'
require_relative 'view_import'

ViewNotFound = Class.new(NameError)

class View
  attr_reader :data
  alias entity data

  extend ViewDSL
  extend ViewImport

  def self.for(*entities)
    views = entities.flatten.map do |entity|
      for_class(entity.class).new(entity)
    end

    views.size == 1 ? views.first : views
  end

  def self.for_class(klass)
    view_class = const_get("#{klass.name}View") rescue nil

    if view_class.nil?
      view_class = self.for_class(klass.superclass) or fail ViewNotFound
    end

    view_class
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
    when Symbol, String
      result = if respond_to?(field)
                 send(field)
               else
                 data.public_send(field)
               end

      if result.is_a?(Hash)
        result = result.map { |(k,v)| [normalize(k), v] }.to_h
      end

      { normalize(alias_name) => result }
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
