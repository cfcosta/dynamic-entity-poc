require_dependency 'views/middleware_resource_view'
require_dependency 'entities/wildfly_server'

class WildflyServerView < MiddlewareResourceView
  import_json_file 'lib/schemas/wildfly_server_view.json'
end
