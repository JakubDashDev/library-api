class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  
  before_validation :assign_serial_number, on: :create

  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/ }
  validates :title, presence: true
  validates :author, presence: true

  def current_borrowing
    borrowings.active.first
  end

  def status
    current_borrowing ? "borrowed": "available"
  end

  private
  def assign_serial_number
    return if serial_number.present?

    serial_number = self.class.connection.select_value("SELECT nextval('books_serial_number_seq')")
    self.serial_number = format("%06d", serial_number)
  end
end