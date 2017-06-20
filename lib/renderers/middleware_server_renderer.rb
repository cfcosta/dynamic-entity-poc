require_relative '../renderer'

class MiddlewareServerRenderer < Renderer
  def to_json
    MultiJson.dump({ name: target.name })
  end
end
