class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.integer :serial_number, null: false
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
      t.index :serial_number, unique: true
    end
  end
end
