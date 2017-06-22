require 'spec_helper'
require 'view_dsl'

describe ViewDSL::Pane do
  describe '#field' do
    Given(:pane) { ViewDSL::Pane.new(:summary) { field :name } }
    Then { pane.fields == [:name] }
  end

  describe '#pane' do
    context 'empty pane' do
      Given(:pane) { ViewDSL::Pane.new(:summary) }
      Then { pane.name == :summary }
      And { pane.fields == [] }
    end

    context 'pane inside a pane' do
      Given(:pane) { ViewDSL::Pane.new(:summary) { pane(:foo) } }
      Given(:inside_pane) { pane.fields[0] }

      Then { inside_pane.is_a? ViewDSL::Pane }
      And { inside_pane.name == :foo }
      And { inside_pane.fields == [] }
    end
  end
end
