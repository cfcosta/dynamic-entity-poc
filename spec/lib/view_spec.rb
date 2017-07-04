require 'rails_helper'
require 'view'

module MockViews
  class Zero < View
  end

  class Simple < View
    field(:name)
  end

  class Simple2 < View
    field(:name)
    field(:description)
  end

  class WithPane < View
    pane(:foo) { field(:name) }
  end

  class NestedPane < View
    pane(:foo) { pane(:bar) { field(:name) } }
  end

  class PaneAndField < View
    pane(:foo) { field :name }
    field :baz
  end

  class AttributeTransformation < View
    field :foo_bar
  end
end

RSpec.describe View do
  def json!(val)
    MultiJson.dump(val)
  end

  describe '#render_json' do
    context 'empty entity' do
      Given(:view) { MockViews::Zero.new({}) }
      Then { view.render_json == '{}' }
    end

    context 'one field' do
      Given(:object) { double(name: 'hello') }
      Given(:view) { MockViews::Simple.new(object) }
      Given(:result) { json!(name: 'hello') }

      Then { view.render_json == result }
    end

    context 'many fields' do
      Given(:object) { double(name: 'hello', description: 'world') }
      Given(:view) { MockViews::Simple2.new(object) }
      Given(:result) { json!(name: 'hello', description: 'world') }

      Then { view.render_json == result }
    end

    context 'panes' do
      Given(:object) { double(name: 'hello') }
      Given(:view) { MockViews::WithPane.new(object) }
      Given(:result) { json!(foo: { name: 'hello' }) }

      Then { view.render_json == result }
    end

    context 'nested panes' do
      Given(:object) { double(name: 'hello') }
      Given(:view) { MockViews::NestedPane.new(object) }
      Given(:result) { json!(foo: { bar: { name: 'hello' } }) }

      Then { view.render_json == result }
    end

    context 'panes and fields' do
      Given(:object) { double(name: 'hello', baz: 'baz') }
      Given(:view) { MockViews::PaneAndField.new(object) }
      Given(:result) { json!(foo: { name: 'hello' }, baz: 'baz') }

      Then { view.render_json == result }
    end

    context 'attribute name transformation' do
      Given(:object) { double(foo_bar: 'hello') }
      Given(:view) { MockViews::AttributeTransformation.new(object) }
      Given(:result) { json!(fooBar: 'hello') }

      Then { view.render_json == result }
    end
  end
end
