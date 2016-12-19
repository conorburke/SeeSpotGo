class Space < ApplicationRecord
  belongs_to :location
  has_one :owner, through: :location
  has_many :reservations

  SIZES = %w(motorcycle compact standard large RV)

  validates_presence_of :location
  validates :size, inclusion: { in: SIZES, message: "%{value} is not a valid size" }
  validates :space_active, inclusion: { in: [0,1] }
end
