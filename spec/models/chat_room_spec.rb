require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:location) }
    it { should have_many(:messages) }
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
