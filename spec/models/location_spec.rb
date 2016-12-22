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

  describe '#average_rating' do
    let (:user) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")}
    let (:rater) {User.create(first_name: "Chelsey", last_name: "Lin", email: "chelsey@gmail.com", password: "123456", phone: "023-456-7890")}
    let (:location) {Location.create(user_id: user.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")}
    let (:space) {Space.create(location_id: location.id, price: 2)}
    let (:reservation) {Reservation.create(space_id: space.id, occupant_id: rater.id, start_time: '2016-12-25 08:00:00', end_time: '2016-12-25 10:00:00')}

    it 'returns 0 if there are no ratings' do
      expect(location.average_rating).to eq 0
    end
    it 'checks the average location score' do
      Rating.create(reservation_id: reservation.id, user_id: user.id, rater_id: rater.id, score: 4, comment: "good job")
      expect(location.average_rating).to eq 4
    end
  end
end
