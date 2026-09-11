class CustomerBlueprint < Blueprinter::Base
  identifier :id

  field :library_card_number
  field :full_name
  field :email
end