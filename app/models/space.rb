class Space < ApplicationRecord
  belongs_to :location
  has_one :owner, through: :location, foreign_key: :user_id

  validates_presence_of :location, :owner, :description
  validates :size, inclusion: { in: %w(motorcycle compact standard large RV),
    message: "%{value} is not a valid size" }
  validates :space_active, inclusion: { in: [0,1] }
end
