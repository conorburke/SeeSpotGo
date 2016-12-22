class AddLocationIdToChatRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_rooms, :location_id, :integer
  end
end
