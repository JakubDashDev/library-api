class CustomersController < ApplicationController
  def index
    render json: CustomerBlueprint.render(Customer.all)
  end

  def show
    render json: CustomerBlueprint.render(customer)
  end

  def create
    new_customer = Customer.new(customer_params)

    if new_customer.save
      render json: CustomerBlueprint.render(new_customer), status: :created
    else
      render json: { errors: new_customer.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def customer_params
    params.permit(:full_name, :email)
  end

  def customer
    Customer.find(params[:id])
  end
end
