class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.integer :space_id, null: false
      t.integer :occupant_id, null: false
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
