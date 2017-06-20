require 'rails_helper'

RSpec.describe MiddlewareEntity, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:klass) }
  it { is_expected.to validate_presence_of(:metadata) }
end
