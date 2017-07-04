require 'spec_helper'
require 'entity'

class MockEntity < Entity
  attr_reader :data

  def self.applicable?(data)
    data[:foo] == :bar
  end

  def initialize(data)
    @data = data
  end
end

class HigherPriorityMockEntity < Entity
  def self.applicable?(data)
    true
  end
end

describe Entity do
  describe '.applicable?' do
    Then 'raises error on base class' do
      expect { described_class.applicable?(nil) }.to raise_error NotImplementedError
    end
  end

  describe '.register' do
    after { Entity.unregister(entity) }

    Given(:entity) { Object.new }
    When { Entity.register(entity) }
    Then { Entity.registered_entities.include?(entity) }

    context 'in subclass' do
      When { MockEntity.register(entity) }
      Then { Entity.registered_entities.include?(entity) }
    end
  end

  describe 'constantize' do
    Given(:metadata) { {foo: :bar} }

    after { Entity.unregister(MockEntity) }

    When { Entity.register(MockEntity) }

    context 'raises error if metadata do not comply to requirements' do
      When { metadata.delete(:foo) }
      Then { expect { Entity.constantize(metadata)}.to raise_error Entity::NoMatchedEntity }
    end

    context 'returns a new object' do
      When(:result) { Entity.constantize(metadata) }

      Then { result.is_a? MockEntity }
      And { result.data == metadata }
    end

    context 'sorts by weight' do
      after { Entity.unregister(HigherPriorityMockEntity) }
      before { Entity.register(HigherPriorityMockEntity, weight: 999) }

      When(:result) { Entity.constantize(metadata) }

      Then { result.is_a? HigherPriorityMockEntity }
    end
  end
end
