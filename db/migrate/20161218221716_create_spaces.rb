class CreateSpaces < ActiveRecord::Migration[5.0]
  def change
    create_table :spaces do |t|
      t.integer :location_id, null: false
      t.string :size, default: "standard"
      t.string :description
      t.integer :space_active, default: 0

      t.timestamps
    end
  end
end
