require_dependency 'view'

class MiddlewareResourceView < View
  pane :summary do
    field :id
    field :name
    field :feed
    field :type_path
    field :path
  end
end
