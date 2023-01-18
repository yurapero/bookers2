class BooksController < ApplicationController
  
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  
  def new
  end

  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :index
    end
  end

  def index
    @book = Book.new
    @books = Book.all
    @users = User.all
  end

  def show
    @book = Book.find(params[:id]) 
    
  end 
  
  def edit
    is_matching_login_user
    @book = Book.find(params[:id]) 
  end
  
  def update
    is_matching_login_user
    book = Book.find(params[:id])
    if book.update(book_params)
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(book.id)
    else
      render :edit
    end
    
  end
  
  def destroy
    is_matching_login_user
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'
  end
  
  
  
  private
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unlsss @user == current_user
    redirect_to(books_path)
  end
  
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
  
end
