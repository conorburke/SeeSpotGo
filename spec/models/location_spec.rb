require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "Associations" do
    it { should belong_to(:owner).class_name('User').with_foreign_key('user_id') }
    it { should have_many(:spaces) }
    it { should have_many(:active_spaces).conditions(space_active: 1).class_name('Space') }
    it { should have_many(:reservations).through(:spaces) }
  end

  describe "Validations" do
    it { should validate_presence_of(:owner) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_inclusion_of(:state).in_array(Location::STATES) }
    it { should allow_values('94124', '23512').for(:zip) }
    it { should_not allow_values('3412', '235123', 'lemon').for(:zip) }
  end
end
