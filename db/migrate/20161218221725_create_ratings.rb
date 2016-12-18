class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :reservation_id, null: false
      t.integer :user_id, null: false
      t.integer :rater_id, null: false
      t.integer :score
      t.string :comment

      t.timestamps
    end
  end
end
