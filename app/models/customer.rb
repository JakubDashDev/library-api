class Customer < ApplicationRecord
  before_validation :assign_library_card_number, on: :create
  before_validation :normalize_email

  validates :library_card_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/ }
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private
  def assign_library_card_number
    return if library_card_number.present?

    card_number = self.class.connection.select_value("SELECT nextval('customers_library_card_number_seq')")
    self.library_card_number = format("%06d", card_number)
  end

  def normalize_email
    self.email = email.downcase if email.present?
  end
end