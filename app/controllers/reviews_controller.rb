class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @user = User.joins(:driver).find(params[:format])
    @reviews = Review.joins(:user).where("reviews.driver_id = ?", @user.driver_id).order(data: :desc)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    @user = User.joins(:driver).find(params[:format])
  end

  # POST /reviews
  # POST /reviews.json

  def create
    @review = Review.new(review_params)
    user = User.find(@review.driver_id)
    exist = Review.where("user_id = ? and driver_id = ?", current_user.id, user.driver_id).exists?
    @review.driver_id = user.driver_id
    @review.data = DateTime.current
    @review.user_id = current_user.id
    @review.deleted = false
    respond_to do |format|
      if !exist && @review.save
        format.html { redirect_to reviews_path(user.id), notice: 'Review was successfully created.' }
        format.json { render :index, status: :created, location: @review }
      elsif exist
        format.html { redirect_to new_review_path(user.id), notice: error_one }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to new_review_path(user.id), notice: error_two }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params[:vote] = params[:vote].to_i
    params.require(:review).permit( :vote, :commento, :driver_id)
  end
end
