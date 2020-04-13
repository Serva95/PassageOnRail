class ReviewsController < ApplicationController
  before_action :set_review, only: [:destroy]

  # GET /reviews
  def index
    @user = Review.find_user(params[:user_id])
    @reviews = Review.find_reviews(@user.driver_id)
  end

  # GET /reviews/new
  def new
    @review = Review.new
    @user = Review.find_user(params[:user_id])
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)
    user = User.find(@review.user_id)
    same_user = user.id == current_user.id
    unless same_user
      exist = Review.exists(current_user.id, user.driver_id)
      @review.driver_id = user.driver_id
      @review.data = DateTime.current
      @review.user_id = current_user.id
      done = Review.has_previous_journey_done(current_user.id, user.driver_id)
    end
    respond_to do |format|
      if same_user
        format.html { redirect_to new_review_path(user_id: user.id), notice: "Error same user" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      else
        if !exist && done && Review.new_review_transaction(@review)
          format.html { redirect_to reviews_path(user_id: user.id), notice: 'Review was successfully created.' }
          format.json { render :index, status: :created, location: @review }
        elsif exist
          format.html { redirect_to new_review_path(user_id: user.id), notice: Review.error_one }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        elsif !done
          format.html { redirect_to new_review_path(user_id: user.id), notice: "Errore not done" }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to new_review_path(user_id: user.id), notice: Review.error_two }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params[:vote] = params[:vote].to_i
    params.require(:review).permit( :vote, :commento, :user_id)
  end
end
