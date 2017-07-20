require_dependency 'entity'

Dir.glob(Rails.root.join("lib", "entities", "*.rb")) do |entity|
  require_dependency entity
end

require_dependency 'view_dsl'
require_dependency 'view_import'
require_dependency 'view'

Dir.glob(Rails.root.join("lib", "views", "*.rb")) do |view|
  require_dependency view
end

require_dependency 'entity_mapper'
require_dependency 'hawkular_connection'
require_dependency 'hawkular_resource_collection'

class TestController < ApplicationController
  def index
    resources = HawkularConnection.new.get_all_resources

    render json: View.for(resources)
  end
end
