class BorrowingBlueprint < Blueprinter::Base
  identifier :id

  field :borrowed_at
  field :due_date
  field :returned_at

  association :customer, blueprint: CustomerBlueprint
end