require 'rails_helper'
require 'view'
require 'entity'

MockView = Class.new(View)
Mock = Class.new(Entity)
Stub = Class.new(Mock)

List = Class.new(Entity)
ListView = Class.new(View)

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

  class Subclassed < Simple
    field :bar
  end

  class Alias < View
    field :name, :full_name
  end

  class MessageChain < View
    field 'bar.baz', :foo
  end

  class AttributeTransformation < View
    field :foo_bar
  end

  class FromYAML < View.from_yaml_file('spec/fixtures/view_import.yml')
  end

  class FromJSON < View.from_json_file('spec/fixtures/view_import.json')
  end
end

RSpec.describe View do
  def json!(val)
    MultiJson.dump(val)
  end

  describe '.for' do
    context 'same class' do
      Given(:klass) { 'Mock' }

      Then { View.for(klass) == MockView }
      Then { expect { View.for('foobar') }.to raise_error(ViewNotFound) }
    end

    context 'superclasses' do
      Given(:klass) { 'Stub' }

      Then { View.for(klass) == MockView }
    end

    context 'list' do
      Given(:list) { 'List' }
      Given(:mock) { 'Mock' }

      Then { View.for(list, mock) == [ListView, MockView] }
    end
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

    context 'alias' do
      Given(:object) { double(name: :baz) }
      Given(:view) { MockViews::Alias.new(object) }
      Given(:result) { json!(fullName: :baz) }

      Then { view.render_json == result }
    end

    context 'subclassed' do
      Given(:object) { double(name: 'hello', bar: 'bar') }
      Given(:view) { MockViews::Subclassed.new(object) }
      Given(:result) { json!(name: 'hello', bar: 'bar') }

      Then { view.render_json == result }
    end

    context 'attribute name transformation' do
      Given(:object) { double(foo_bar: 'hello') }
      Given(:view) { MockViews::AttributeTransformation.new(object) }
      Given(:result) { json!(fooBar: 'hello') }

      Then { view.render_json == result }
    end

    context 'yaml schema parsing' do
      Given(:object) { double(id: 1, full_name: 'foo', active: true, foo: 'bar') }
      Given(:view) { MockViews::FromYAML.new(object) }
      Given(:result) { json!(summary: {id: 1, isActive: true, name: 'foo'}, foo: 'bar') }

      Then { view.render_json == result }
    end

    context 'json schema parsing' do
      Given(:object) { double(id: 1, full_name: 'foo', active: true, foo: 'bar') }
      Given(:view) { MockViews::FromJSON.new(object) }
      Given(:result) { json!(summary: {id: 1, isActive: true, name: 'foo'}, foo: 'bar') }

      Then { view.render_json == result }
    end
  end
end
