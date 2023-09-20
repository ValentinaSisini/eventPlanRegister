class RemoveCascadeDeleteFromNotifications < ActiveRecord::Migration[7.0]
  def change
    # Rimuove l'opzione on_delete: :cascade dal vincolo di chiave esterna sugli eventi
    remove_foreign_key :notifications, :events
    add_foreign_key :notifications, :events  # Rimuove completamente l'opzione on_delete: :cascade
  end
end
