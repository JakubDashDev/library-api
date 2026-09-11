class ReminderMailer < ApplicationMailer
  def due_soon(borrowing)
    @borrowing = borrowing
    @book = borrowing.book
    @customer = borrowing.customer

    mail(to: @customer.email, subject: "Reminder: \"#{@book.title}\" is due in 3 days")
  end

  def due_today(borrowing)
    @borrowing = borrowing
    @book = borrowing.book
    @customer = borrowing.customer

    mail(to: @customer.email, subject: "Reminder: \"#{@book.title}\" is due today")
  end
end