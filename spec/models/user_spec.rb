require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do

    it { should have_many(:locations) }
    it { should have_many(:received_reservations).through(:spaces).source(:reservations) }
    it { should have_many(:requested_reservations).class_name('Reservation').with_foreign_key(:occupant_id) }
    it { should have_many(:written_ratings).class_name('Rating').with_foreign_key(:rater_id) }
    it { should have_many(:received_ratings).class_name('Rating') }
    it { should have_many(:messages) }
    it { should have_many(:chat_rooms)}
  end

  describe "validations" do
    subject { User.new( first_name: 'Jane',
                        last_name: 'Doe',
                        email: 'jdoe@gmail.com',
                        password: 'likesbikes',
                        phone: '760-434-4344',
                        status: "user") }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_values('760-434-4344').for(:phone) }
    it { should_not allow_values('1760-434-4344', '7x0-434-4344', '1760-434+4344', '1760-43444').for(:phone) }
  end

  describe "methods" do
    let (:user) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")}
    let (:rater) {User.create(first_name: "Chelsey", last_name: "Lin", email: "chelsey@gmail.com", password: "123456", phone: "023-456-7890")}
    let (:location) {Location.create(user_id: user.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")}
    let (:space) {Space.create(location_id: location.id, price: 2)}
    let (:reservation) {Reservation.create(space_id: space.id, occupant_id: rater.id, start_time: '2016-12-25 08:00:00', end_time: '2016-12-25 10:00:00')}

    describe '#average_rating' do

        it 'returns 0 if there are no ratings' do
            expect(user.average_rating).to eq 0
        end

        it 'checks the average user score' do
            Rating.create(reservation_id: reservation.id, user_id: user.id, rater_id: rater.id, score: 4, comment: "good job")
            expect(user.average_rating).to eq 4
        end

    end

    it 'returns full name of user' do
        expect(user.full_name).to eq "Conor Burke"
    end
  end
end




