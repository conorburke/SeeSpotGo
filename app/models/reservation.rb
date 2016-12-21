class Reservation < ApplicationRecord
  belongs_to :occupant, class_name: :User
  belongs_to :space
  has_many :ratings

  validates :space_id, presence: true
  validates :occupant_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :ensure_start_time_is_valid_datetime
  validate :ensure_end_time_is_valid_datetime

  validate :start_time_is_in_future, on: :create
  validate :end_time_is_in_future, on: :create

  validates :start_time, :end_time, :overlap => {scope: "space_id", exclude_edges: ["starts_at", "ends_at"]}

  def ensure_start_time_is_valid_datetime
    errors.add(:start_time, 'must be a valid datetime') unless (self.start_time.is_a?(ActiveSupport::TimeWithZone))
  end

  def ensure_end_time_is_valid_datetime
    errors.add(:end_time, 'must be a valid datetime') unless (self.end_time.is_a?(ActiveSupport::TimeWithZone))
  end

  def start_time_is_in_future
    errors.add(:start_time, 'must be in the future') if (self.start_time && self.start_time.past?)
  end

  def end_time_is_in_future
    errors.add(:end_time, 'must be in the future') if (self.end_time && self.end_time.past?)
  end

  # Behaviors

  def overlap?(start_time, end_time)
    ((start_time > self.end_time) || (end_time < self.start_time)) ? false : true
  end
end
