require 'rails_helper'

RSpec.describe Message, type: :model do
  
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:chat_room) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(2) }
    it { should validate_length_of(:body).is_at_most(1000) }
  end

  describe "methods" do 
    it 'should be in the correct time format' do
      user = User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")
      location = Location.create(user_id: user.id, street_address: "707 Broadway Avenue", city: "San Diego", state: "CA", zip: "92101")
      chat_room = ChatRoom.create(title: "testing", user_id: user.id, location_id: location.id)
      message = Message.create(body: "test", user_id: user.id, chat_room_id: chat_room.id)
      expect(Date.parse(message.timestamp)).to be_a_kind_of(Date) 
    end
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
