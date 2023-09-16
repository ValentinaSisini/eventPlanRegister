class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, limit: 255
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.text :location
      t.integer :max_participants
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
