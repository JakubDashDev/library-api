class DropSerialNumberSequences < ActiveRecord::Migration[8.1]
  def up
    execute "DROP SEQUENCE IF EXISTS books_serial_number_seq;"
    execute "DROP SEQUENCE IF EXISTS customers_library_card_number_seq;"
  end

  def down
    execute "CREATE SEQUENCE books_serial_number_seq START WITH 1 MINVALUE 1 MAXVALUE 999999;"
    execute "CREATE SEQUENCE customers_library_card_number_seq START WITH 1 MINVALUE 1 MAXVALUE 999999;"
  end
end
