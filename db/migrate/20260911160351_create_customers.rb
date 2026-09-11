class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :library_card_number, null: false, limit: 6
      t.string :full_name, null: false
      t.string :email, null: false
      t.timestamps

      t.index :library_card_number, unique: true
      t.index "lower(email)", unique: true, name: "index_customers_on_unique_email"
      t.check_constraint "library_card_number ~ '^[0-9]{6}$'", name: "customers_library_card_number_format"
    end

    reversible do |dir|
      dir.up { execute "CREATE SEQUENCE customers_library_card_number_seq START WITH 1 MINVALUE 1 MAXVALUE 999999;" }
      dir.down { execute "DROP SEQUENCE IF EXISTS customers_library_card_number_seq;" }
    end
  end
end
