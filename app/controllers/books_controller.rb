class BooksController < ApplicationController
  def index
    render json: BookBlueprint.render(Book.all)
  end

  def show
    render json: BookBlueprint.render(book, view: :detailed)
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: BookBlueprint.render(book), status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    book.destroy
    head :no_content
  end

  def borrow
    new_borrowing = book.borrowings.new(borrow_params)

    if new_borrowing.save
      render json: BookBlueprint.render(book), status: :created
    else
      render json: { errors: new_borrowing.errors.full_messages }, status: :unprocessable_content
    end
  end

  def return
    current_borrowing = book.current_borrowing

    if current_borrowing.nil?
      render json: { errors: [ "Book is not currently borrowed" ] }, status: :unprocessable_content
    else
      current_borrowing.update!(returned_at: Time.current)
      render json: BookBlueprint.render(book)
    end
  end

  private
  def book_params
    params.permit(:title, :author)
  end

  def book
    Book.find(params[:id])
  end

  def borrow_params
    params.permit(:customer_id)
  end
end
