class AddColumnPriceToSpace < ActiveRecord::Migration[5.0]
  def change
    add_column :spaces, :price, :float, null: false
  end
end
