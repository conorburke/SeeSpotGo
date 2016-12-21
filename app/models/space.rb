class Space < ApplicationRecord
  belongs_to :location
  has_one :owner, through: :location
  has_many :reservations

  SIZES = %w(motorcycle compact standard large RV)

  validates_presence_of :location, :price
  validates :size, inclusion: { in: SIZES, message: "%{value} is not a valid size" }
  validates :space_active, inclusion: { in: [0,1] }
  validates :price, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 999 }

  def active?
    self.space_active == 1
  end

  def space_available?(params)
    price = params[:price] || 999
    size = params[:size] || self.size
    start_time = params[:start_time] || Time.zone.now
    end_time = params[:end_time] || Time.zone.now

    self.active? && self.price <= price && self.size == size && self.time_available?(start_time, end_time)
  end

  def time_available?(start_time, end_time)
    !(self.reservations.find { |reservation| reservation.overlap?(start_time, end_time) })
  end
end
