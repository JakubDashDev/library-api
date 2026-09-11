class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :serial_number, null: false, limit: 6
      t.string :title, null: false
      t.string :author, null: false
      t.timestamps
      
      t.index :serial_number, unique: true
      t.check_constraint "serial_number ~ '^[0-9]{6}$'", name: "books_serial_number_format"
    end

    reversible do |dir|
      dir.up { execute "CREATE SEQUENCE books_serial_number_seq START WITH 1 MINVALUE 1 MAXVALUE 999999;" }
      dir.down { execute "DROP SEQUENCE IF EXISTS books_serial_number_seq;" }
    end
  end
end
