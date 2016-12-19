class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rater, class_name: :User
  belongs_to :reservation
  has_one :space, through: :reservation
  has_one :location, through: :space

  validates :user, :rater, :reservation, :score, presence: true
  validates :user, uniqueness: { scope: :reservation_id }
  validates :rater, uniqueness: { scope: :reservation_id }
  validates :score, inclusion: { in: [1, 2, 3, 4, 5], message: "%{value} is not a valid score" }
  # validate :valid_users

  # def valid_users
  #   unless self.user != self.rater
  #     return errors.add :rater, "cannot rate own account"
  #   end

  #   unless [self.user, self.rater].to_set == [self.location.owner, self.reservation.occupant].to_set
  #     errors.add :user, "or rater is invalid"
  #   end
  # end
end
