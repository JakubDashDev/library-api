class AddReminderJobIdsToBorrowings < ActiveRecord::Migration[8.1]
  def change
    add_column :borrowings, :due_soon_job_id, :string
    add_column :borrowings, :due_today_job_id, :string
  end
end
