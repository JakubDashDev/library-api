class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :customer

  before_validation :set_borrows_date, on: :create
  validate :book_not_already_borrowed, on: :create

  after_create_commit :schedule_reminders
  after_update_commit :cancel_reminders, if: :saved_change_to_returned_at?

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
    due_soon_job = ReminderJob.set(wait_until: due_date - 3.days).perform_later(id, "due_soon")
    due_today_job = ReminderJob.set(wait_until: due_date).perform_later(id, "due_today")

    update_columns(due_soon_job_id: due_soon_job.job_id, due_today_job_id: due_today_job.job_id)
  end

  def cancel_reminders
    cancel_scheduled_job(due_soon_job_id)
    cancel_scheduled_job(due_today_job_id)
  end

  def cancel_scheduled_job(active_job_id)
    return if active_job_id.blank?

    job = SolidQueue::Job.find_by(active_job_id: active_job_id)
    execution = job&.scheduled_execution || job&.ready_execution || job&.claimed_execution
    execution&.discard
  end
end