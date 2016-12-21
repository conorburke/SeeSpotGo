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

  describe 'behaviors' do
    let (:user) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")}
    let (:location) {Location.create(user_id: user.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")}
    let (:space) {Space.create(location_id: location.id, price: 2, space_active: 1)}

    context '#active?' do
      it 'returns true if space is active' do
        expect(space.active?).to be true
      end

      it 'returns false if space is not active' do
        space.update_attribute(:space_active, 0)
        expect(space.active?).to be false
      end
    end

    context "#space_available" do
      it 'returns true if price offered is higher' do
        expect(space.space_available?({})).to be true
      end

      it 'returns false if price offered is lower' do
        expect(space.space_available?({price: 0})).to be false
      end

      it 'returns false if space is not active' do
        space.update_attribute(:space_active, 0)
        expect(space.space_available?({})).to be false
      end

      it 'returns false if it is different size' do
        expect(space.space_available?({size: "RV"})).to be false
      end
    end
  end
end
