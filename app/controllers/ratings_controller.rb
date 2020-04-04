class RatingsController < ApplicationController
  before_action :set_rating, only: [:destroy]

  # GET /ratings
  def index
    @user = User.find(params[:format])
    @ratings = Rating.find_ratings(@user.id)
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
    @user = User.find(params[:format])
  end

  # POST /ratings
  def create
    @rating = Rating.new(rating_params)
    @rating.data = DateTime.current
    @rating.driver_id = current_user.driver_id
    exist = Rating.exists(@rating.user_id, current_user.driver_id)
    respond_to do |format|
      if !exist && @rating.save
        format.html { redirect_to ratings_path(@rating.user_id), notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      elsif exist
        format.html { redirect_to @rating, notice: Rating.error_one }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to @rating, notice: Rating.error_two }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params[:vote] = params[:vote].to_i
    params.require(:rating).permit(:vote, :user_id)
  end
end
