class ReminderJob < ApplicationJob
  queue_as :default

  def perform(borrowing_id, kind)
    borrowing = Borrowing.find_by(id: borrowing_id)
    return if borrowing.nil? || borrowing.returned?

    case kind
    when "due_soon"
      ReminderMailer.due_soon(borrowing).deliver_now
    when "due_today"
      ReminderMailer.due_today(borrowing).deliver_now
    end
  end
end