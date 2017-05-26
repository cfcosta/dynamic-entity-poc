require 'spec_helper'
require 'entity'

class MockEntity
  attr_reader :data

  def self.applicable?(data)
    data[:foo] == :bar
  end

  def initialize(data)
    @data = data
  end
end

describe Entity do
  describe '.applicable?' do
    Then 'raises error on base class' do
      expect { described_class.applicable?(nil) }.to raise_error NotImplementedError
    end
  end

  describe '.register' do
    after { Entity.registered_entities.delete(entity) }

    Given(:entity) { Object.new }
    When { Entity.register(entity) }
    Then { Entity.registered_entities.include?(entity) }
  end

  describe 'constantize' do
    Given(:entity) { instance_double('MiddlewareEntity', klass: 'MockEntity', metadata: metadata) }
    Given(:metadata) { {foo: :bar} }

    context 'raises error if not registered' do
      Then { expect { Entity.constantize(entity)}.to raise_error Entity::UnknownClass }
    end

    context 'registered' do
      after { Entity.registered_entities.delete(MockEntity) }
      When { Entity.register(MockEntity) }

      context 'raises error if metadata do not comply to requirements' do
        When { metadata.delete(:foo) }
        Then { expect { Entity.constantize(entity)}.to raise_error Entity::UnmatchedData }
      end

      context 'returns a new object' do
        When(:result) { Entity.constantize(entity) }

        Then { result.is_a? MockEntity }
        And { result.data == metadata }
      end
    end
  end
end
