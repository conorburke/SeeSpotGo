require 'rails_helper'

RSpec.describe Space, type: :model do
  describe 'associations' do
    it { should belong_to(:location) }
    it { should have_one(:owner) }
  end

  describe 'validations' do
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:owner) }
    it { should validate_presence_of(:size) }
  end
end
