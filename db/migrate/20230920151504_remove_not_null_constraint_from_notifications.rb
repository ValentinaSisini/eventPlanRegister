class RemoveNotNullConstraintFromNotifications < ActiveRecord::Migration[7.0]
  def change
    change_column :notifications, :event_id, :integer, null: true
  end
end
