class Space < ApplicationRecord
  belongs_to :location
  has_one :owner, through: :location

  validates :location, presence: true
  validates :owner, presence: true
  validates :size, inclusion: { in: %w(motorcycle compact standard large RV),
    message: "%{value} is not a valid size" }
  validates :description, presence: true
  validates :space_active, inclusion: { in: [0,1] }
end
