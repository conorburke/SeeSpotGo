require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'methods' do
    let (:user) {User.create(first_name: "Conor", last_name: "Burke", email: "conor@gmail.com", password: "123456", phone: "123-456-7890")}
    let(:location) {Location.create(user_id: user.id,
              street_address: "770 Fifth Ave",
              city: "San Diego",
              state: "CA",
              zip: "92101")}
    let (:space) {Space.create(location_id: location.id, space_active: 1, price: 2)}
    let(:search) {Search.new(search: "707 Broadway, San Diego, CA 92102",
                  miles: "5",
                  size: "standard",
                  constrain: "any",
                  price: "2",
                  start_time: "2016-12-25 08:00:00",
                  end_time: "2016-12-25 10:00:00")}
    let(:search2) {Search.new(
                  miles: "1",
                  size: "standard",
                  constrain: "any",
                  price: "2",
                  start_time: "2016-12-25 08:00:00",
                  end_time: "2016-12-25 10:00:00")}
    let(:search4) {Search.new(search: "707 Broadway, San Diego, CA 92102",
                  miles: "1",
                  size: "standard",
                  constrain: "any",
                  price: "2")}
    let(:search5) {Search.new(search: "707 Broadway, San Diego, CA 92102",
                  miles: "5",
                  size: "standard",
                  start_time: "2016-12-25 08:00:00",
                  end_time: "2016-12-25 10:00:00")}



    it "checks to see if search is valid" do
      expect(search.valid?).to be true
    end

    it "has a search with no location" do
      search2.valid?
      expect(search2.errors).to include "Location is not valid"
    end

    it "errors when no date is given" do
      search4.valid?
      expect(search4.errors).to include "Start/End time is not valid"
    end

    it "returns the location in range when searched for" do
      p space
      expect(search.search_locations).to include location
    end

    it "returns a price error" do
      search5.valid?
      expect(search5.errors).to include "Price is not valid"
    end

  end

  # pending "add some examples to (or delete) #{__FILE__}"
end
