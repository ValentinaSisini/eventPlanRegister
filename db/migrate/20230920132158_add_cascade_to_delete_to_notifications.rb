class AddCascadeToDeleteToNotifications < ActiveRecord::Migration[7.0]
  def change
     # Aggiunge l'opzione on_delete: :cascade al vincolo di chiave esterna sugli eventi
     remove_foreign_key :notifications, :events
     add_foreign_key :notifications, :events, on_delete: :cascade
 
     # Aggiunge l'opzione on_delete: :cascade al vincolo di chiave esterna sugli utenti
     remove_foreign_key :notifications, :users
     add_foreign_key :notifications, :users, on_delete: :cascade
  end
end
