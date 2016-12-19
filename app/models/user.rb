class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :locations
  has_many :spaces, through: :locations
  has_many :received_reservations, through: :spaces, source: :reservations
  has_many :requested_reservations, class_name: :Reservation, foreign_key: :occupant_id
  has_many :written_ratings, class_name: :Rating, foreign_key: :rater_id
  has_many :received_ratings, class_name: :Rating

  validates :first_name, :last_name, :phone, presence: true
  validate :valid_phone

  def valid_phone
    unless self.phone =~ /^\d{3}-\d{3}-\d{4}$/ # Ex: "619-643-8612"
      errors.add :phone, "number must be valid format"
    end
  end

  def average_rating
    ratings = self.received_ratings.pluck(:score)
    ratings.reduce(:+) ? (ratings.reduce(:+)/ratings.size.to_f).round(1) : 0
  end
end
