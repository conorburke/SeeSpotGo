require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create(
        first_name: "Conor",
        last_name: "Burke",
        email: "cjburke89@gmail.com",
        password_digest: "1234",
        phone: "717-608-8969",
        status: "user"
    )}

  describe "associations" do

    it { should have_many(:locations) }
    it { should have_many(:reservations) }

    it 'has ratings' do
      rating = Rating.create(user_id: user.id, rater_id: 2, score: 5, comment: "", reservation_id: 1)
      expect(user.ratings.first).to eq rating
    end

    it 'has an average rating' do
      expect(user.average_rating).to eq 0
      rating = Rating.create(user_id: user.id, rater_id: 2, score: 5, comment: "", reservation_id: 1)
      expect(user.average_rating).to eq 5
    end
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
    it { should validate_presence_of(:status) }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_values('760-434-4344').for(:phone) }
    it { should allow_values('760-454-4384').for(:phone) }
    it { should_not allow_values('1760-434-4344').for(:phone) }
    it { should_not allow_values('7x0-434-4344').for(:phone) }
    it { should_not allow_values('1760-434+4344').for(:phone) }
    it { should_not allow_values('1760-43444').for(:phone) }
    it { should_not allow_values('174').for(:phone) }

  end
end
