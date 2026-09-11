class Customer < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  before_validation :assign_library_card_number, on: :create
  before_validation :normalize_email

  validates :library_card_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/ }
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private
  def assign_library_card_number
    return if library_card_number.present?

    loop do
      candidate = format("%06d", rand(1..999_999))
      unless self.class.exists?(library_card_number: candidate)
        self.library_card_number = candidate
        break
      end
    end
  end

  def normalize_email
    self.email = email.downcase if email.present?
  end
end