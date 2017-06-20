require 'spec_helper'
require 'renderer'

MockRenderer = Class.new(Renderer)

RSpec.describe Renderer do
  describe '.for' do
    Given(:klass) { 'Mock' }

    Then { Renderer.for(klass) == MockRenderer }
    Then { expect { Renderer.for('foobar') }.to raise_error(RendererNotFound) }
  end

  describe '#target' do
    Given(:target) { double }
    Given(:renderer) { MockRenderer.new(target) }

    Then { renderer.target == target }
  end

  describe '#to_json' do
    Given(:renderer) { MockRenderer.new(nil) }

    Then { expect { renderer.to_json }.to raise_error(NotImplementedError) }
  end
end
