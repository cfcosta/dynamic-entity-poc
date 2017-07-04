require 'rails_helper'
require 'views/wildfly_server_view'

RSpec.describe WildflyServerView do
  Given(:data) {
    WildflyServer.new(
      name: 'Wildfly Server Example',
      type_path: '/t;hawkular/f;c5be0849abea/rt;WildFly%20Server',
      properties: {
        'Bound Address' => '127.0.0.1',
        'Product Name' => 'Hawkular',
        'Version' => '1.0.0.0'
      },
      metrics: []
    )
  }
  Given(:view) { WildflyServerView.new(data) }

  describe '#render_json' do
    Given(:json) { view.render_json }

    Then { expect(json).to match_json_schema(:wildfly_server, strict: true) }
  end

  xdescribe '#render_schema' do
    Given(:schema) { view.render_schema }
    Then do
      expect(schema).to match_json_schema(:wildfly_server_schema, strict: true)
    end
  end
end
