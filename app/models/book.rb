class Book < ApplicationRecord
  before_validation :assign_serial_number, on: :create

  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/ }
  validates :title, presence: true
  validates :author, presence: true

  private
  def assign_serial_number
    return if serial_number.present?

    next_value = self.class.connection.select_value("SELECT nextval('books_serial_number_seq')")
    self.serial_number = format("%06d", next_value)
  end
end