require 'rails_helper'

RSpec.describe Rating, type: :model do
  # let(:owner) { User.create(first_name: "Chelsey", last_name: "Lin", password_digest: "1234", email: "chelsey@gmail.com", phone: "123-456-7890") }
  # let(:occupant) { User.create(first_name: "Chelsey", last_name: "Linn", password_digest: "1234", email: "chelseylin@gmail.com", phone: "123-456-7890") }
  # let(:location) { Location.create(user_id: owner.id, street_address: "108 Peak Road", city: "San Diego", state: "CA", zip: "93510") }
  # let(:space) { Space.create(location_id: location.id, description: "q3sdfnoiwe") }
  # let(:reservation) { Reservation.create(space_id: space.id, start_time: "2017-01-01 08:00:00", end_time: "2017-01-01 10:00:00", occupant_id: occupant.id) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:rater).class_name('User') }
    it { should belong_to(:reservation) }
    it { should have_one(:space).through(:reservation) }
    it { should have_one(:location).through(:space) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:rater) }
    it { should validate_presence_of(:reservation) }
    it { should validate_presence_of(:score) }
    it { should validate_inclusion_of(:score).in_array([1, 2, 3, 4, 5]) }
  end
end
