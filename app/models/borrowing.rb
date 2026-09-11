class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :customer

  before_validation :set_borrows_date, on: :create
  validate :book_not_already_borrowed, on: :create

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
end