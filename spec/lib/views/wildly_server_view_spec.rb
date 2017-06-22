require 'rails_helper'
require 'views/wildfly_server_view'

RSpec.describe WildflyServerView do
  Given(:data) { WildflyServer.new(name: 'foo') }
  Given(:view) { WildflyServerView.new(data) }

  describe '#render_json' do
    Then { expect(view.render_json).to match_json_schema(:wildfly_server) }
  end

  describe '#render_schema' do
  end
end
