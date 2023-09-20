class AddNullifyToNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :notifications, :events
    add_foreign_key :notifications, :events, on_delete: :nullify
  end
end
