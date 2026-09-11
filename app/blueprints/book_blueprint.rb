class BookBlueprint < Blueprinter::Base
  identifier :id

  field :serial_number
  field :title
  field :author

  field :status do |book|
    book.status
  end

  view :detailed do
    include_view :default
    association :borrowings, blueprint: BorrowingBlueprint
  end
end