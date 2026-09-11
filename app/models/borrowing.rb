class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :customer

  before_validation :set_borrows_date, on: :create
  validate :book_not_already_borrowed, on: :create

  after_create_commit :schedule_reminders

  def returned?
    returned_at.present?
  end

  def self.active
    where(returned_at: nil)
  end

  private
  def set_borrows_date
    self.borrowed_at ||= Time.current
    self.due_date ||= borrowed_at + 30.days
  end

  def book_not_already_borrowed
    return unless book

    errors.add(:book, "is already borrowed") if book.borrowings.active.exists?
  end

  def schedule_reminders
    ReminderJob.set(wait_until: due_date - 3.days).perform_later(id, "due_soon")
    ReminderJob.set(wait_until: due_date).perform_later(id, "due_today")
  end
end