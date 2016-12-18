class Reservation < ApplicationRecord
  belongs_to :space
  belongs_to :occupant, class_name: :User
  has_many :ratings

  validates :space_id, presence: true
  validates :occupant_id, presence: true

  validate :start_time_is_valid_datetime

  def start_time_is_valid_datetime
    errors.add(:happened_at, 'must be a valid datetime') if ((DateTime.parse(happened_at) rescue ArgumentError) == ArgumentError)
  end
end
