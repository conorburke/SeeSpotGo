require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create(
      first_name: "Conor",
      last_name: "Burke",
      email: "cjburke89@gmail.com",
      password_digest: "1234",
      phone: "717-608-8969",
    )}

  describe "associations" do

    it { should have_many(:locations) }
    it { should have_many(:received_reservations).through(:spaces).source(:reservations) }
    it { should have_many(:requested_reservations).class_name('Reservation').with_foreign_key(:occupant_id) }
    it { should have_many(:written_ratings).class_name('Rating').with_foreign_key(:rater_id) }
    it { should have_many(:received_ratings).class_name('Rating') }
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
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:phone) }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_values('760-434-4344').for(:phone) }
    it { should_not allow_values('1760-434-4344', '7x0-434-4344', '1760-434+4344', '1760-43444').for(:phone) }
  end
end
