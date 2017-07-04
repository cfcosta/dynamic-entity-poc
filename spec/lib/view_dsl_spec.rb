require 'spec_helper'
require 'view_dsl'

describe ViewDSL::Pane do
  describe '#field' do
    context 'simple' do
      Given(:pane) { ViewDSL::Pane.new(:summary) { field :name } }
      Then { pane.fields == [[:name, :name]] }
    end

    context 'aliased' do
      Given(:pane) { ViewDSL::Pane.new(:summary) { field :full_name, :name } }
      Then { pane.fields == [[:full_name, :name]] }
    end

    context 'chain' do
      context 'default name' do
        Given(:pane) { ViewDSL::Pane.new(:summary) { field 'foo.bar' } }
        Then { pane.fields == [['foo.bar', :bar]] }
      end

      context 'aliased' do
        Given(:pane) { ViewDSL::Pane.new(:summary) { field 'foo.bar', :furu } }
        Then { pane.fields == [['foo.bar', :furu]] }
      end
    end

    describe '#pane' do
      context 'empty pane' do
        Given(:pane) { ViewDSL::Pane.new(:summary) }
        Then { pane.name == :summary }
        And { pane.fields == [] }
      end

      context 'pane inside a pane' do
        Given(:pane) { ViewDSL::Pane.new(:summary) { pane(:foo) } }
        Given(:inside_pane) { pane.fields[0].first }
        Given(:pane_name) { pane.fields[0].last }

        Then { inside_pane.is_a? ViewDSL::Pane }
        And { pane_name == :foo }
        And { inside_pane.name == :foo }
        And { inside_pane.fields == [] }
      end
    end
  end
end
