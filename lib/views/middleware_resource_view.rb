require_dependency 'view'

class MiddlewareResourceView < View
  import_json_file 'lib/schemas/middleware_resource_view.json'
end
