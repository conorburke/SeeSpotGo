class User < ApplicationRecord
  has_secure_password

  has_many :locations
  has_many :reservations, foreign_key: :occupant_id

  def ratings
    Rating.where("user_id = ? OR rater_id = ?", self.id, self.id)
  end

  def average_rating
    ratings = self.ratings.pluck(:score)
    ratings.reduce(:+) ? ratings.reduce(:+)/ratings.size : 0
  end

  validates :first_name, :last_name, :email, :password_digest, :phone, :status, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  validate :valid_phone

  def valid_phone
    unless self.phone =~ /^\d{3}-\d{3}-\d{4}$/ # Ex: "619-643-8612"
      errors.add :phone, "number must be valid"
    end
  end
end
