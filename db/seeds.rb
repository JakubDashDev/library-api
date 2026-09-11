# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

books = [
  { title: "The Pragmatic Programmer", author: "Andrew Hunt & David Thomas" },
  { title: "Clean Code", author: "Robert C. Martin" },
  { title: "Refactoring", author: "Martin Fowler" },
  { title: "1984", author: "George Orwell" },
  { title: "Dune", author: "Frank Herbert" }
].map do |attrs|
  Book.find_or_create_by!(title: attrs[:title]) { |book| book.author = attrs[:author] }
end

customers = [
  { full_name: "Jane Doe", email: "jane.doe@example.com" },
  { full_name: "John Smith", email: "john.smith@example.com" },
  { full_name: "Alice Johnson", email: "alice.johnson@example.com" }
].map do |attrs|
  Customer.find_or_create_by!(email: attrs[:email]) { |customer| customer.full_name = attrs[:full_name] }
end

# One book currently on loan, so GET /books demonstrates a "borrowed" status.
if books[0].borrowings.none?
  Borrowing.create!(book: books[0], customer: customers[0])
end

# One book already returned, so its history is visible via GET /books/:id.
if books[1].borrowings.none?
  returned_borrowing = Borrowing.create!(book: books[1], customer: customers[1])
  returned_borrowing.update!(returned_at: Time.current)
end

puts "Seeded #{Book.count} books, #{Customer.count} customers, #{Borrowing.count} borrowings."
