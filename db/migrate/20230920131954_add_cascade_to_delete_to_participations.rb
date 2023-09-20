class AddCascadeToDeleteToParticipations < ActiveRecord::Migration[7.0]
  def change
    # Aggiunge l'opzione on_delete: :cascade al vincolo di chiave esterna sugli eventi
    remove_foreign_key :participations, :events
    add_foreign_key :participations, :events, on_delete: :cascade

    # Aggiunge l'opzione on_delete: :cascade al vincolo di chiave esterna sugli utenti
    remove_foreign_key :participations, :users
    add_foreign_key :participations, :users, on_delete: :cascade
  end
end
