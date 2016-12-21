require 'rails_helper'

RSpec.describe Space, type: :model do
  describe 'associations' do
    it { should belong_to(:location) }
    it { should have_one(:owner) }
  end

  describe 'validations' do
    it { should validate_presence_of(:location) }
    it { should validate_inclusion_of(:size).in_array(Space::SIZES) }
    it { should validate_inclusion_of(:space_active).in_array([0, 1]) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:price).is_less_than_or_equal_to(999) }
  end
end
