require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let (:occupant) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")}
  let (:location) {Location.create(user_id: occupant.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")}
  let (:space) {Space.create(location_id: location.id)}
  let (:reservation) {Reservation.create(space_id: space.id, occupant_id: occupant.id, start_time: '2016-12-25 08:00:00', end_time: '2016-12-25 10:00:00')}
  # pending "add some examples to (or delete) #{__FILE__}"

  describe 'associations' do
    it { should belong_to(:occupant) }
    it { should belong_to(:space) }
  end

  describe 'validations' do
    it { should validate_presence_of(:occupant_id) }
    it { should validate_presence_of(:space_id) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end

  describe 'validations for datetime' do
    it 'ensures start_time is a valid time' do
      expect(reservation).to be_valid
    end

    it 'ensures end_time is a valid time' do
      expect(reservation).to be_valid
    end

    it 'ensure improper time format is invalid' do
      reservation2 = Reservation.create(space_id: space.id, occupant_id: occupant.id, start_time: 'tomorrow', end_time: '2016-12-25 10:00:00')
      expect(reservation2).to be_invalid
    end
  end
end
