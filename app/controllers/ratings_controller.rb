class RatingsController < ApplicationController
  before_action :set_rating, only: [:destroy]

  # GET /ratings
  def index
    @user = User.find(params[:user_id])
    @ratings = Rating.find_ratings(@user.id)
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
    @user = User.find(params[:user_id])
  end

  # POST /ratings
  def create
    @rating = Rating.new(rating_params)
    same_user = @rating.user_id == current_user.id
    unless same_user
      @rating.data = DateTime.current
      @rating.driver_id = current_user.driver_id
      exist = Rating.exists(@rating.user_id, current_user.driver_id)
      done = Rating.has_previous_journey_done(@rating.user_id, current_user.driver_id)
    end
    respond_to do |format|
      if same_user
        format.html { redirect_to new_rating_path(user_id: @rating.user_id), notice: "Error same user" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      else
        if !exist && done && Rating.new_rating_transaction(@rating)
          format.html { redirect_to ratings_path(user_id: @rating.user_id), notice: 'Rating was successfully created.' }
          format.json { render :show, status: :created, location: @rating }
        elsif exist
          format.html { redirect_to new_rating_path(user_id: @rating.user_id), notice: Rating.error_one }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        elsif !done
          format.html { redirect_to new_rating_path(user_id: @rating.user_id), notice: "Errore not done" }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to new_rating_path(user_id: @rating.user_id), notice: Rating.error_two }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
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
