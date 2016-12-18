require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let (:occupant) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password_digest: "1234", phone: "123-456-7890")}
  let (:location) {Location.create(user_id: occupant.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")}
  let (:space) {Space.create(location_id: location.id)}
  let (:reservation) {Reservation.create(space_id: space.id, occupant_id: occupant.id)}
  # pending "add some examples to (or delete) #{__FILE__}"
  
  describe 'associations' do 
    it { should belong_to(:occupant) }
    it { should belong_to(:space) }
  end

  describe 'validations' do 
    it { is_expected.to validate_presence_of(:occupant_id) }
    it { is_expected.to validate_presence_of(:space_id) }
  end
end
