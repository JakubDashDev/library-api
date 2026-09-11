class BooksController < ApplicationController
  def index
    render json: Book.all
  end

  def show
    render json: book
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    book.destroy
    head :no_content
  end

  private
  def book_params
    params.permit(:title, :author)
  end

  def book
    Book.find(params[:id])
  end
end
