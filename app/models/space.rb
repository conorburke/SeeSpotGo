class Space < ApplicationRecord
  belongs_to :location
  has_one :owner, through: :location

  validates :location, presence: true
  validates :owner, presence: true


end
