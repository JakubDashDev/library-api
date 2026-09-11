class CreateBorrowings < ActiveRecord::Migration[8.1]
  def change
    create_table :borrowings do |t|
      t.references :book, null: false, foreign_key: { on_delete: :cascade }
      t.references :customer, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :borrowed_at, null: false
      t.datetime :due_date, null: false
      t.datetime :returned_at
      t.timestamps

      t.index :book_id, unique: true, where: "returned_at IS NULL", name: "index_borrowings_on_book_id_when_active"
    end
  end
end
