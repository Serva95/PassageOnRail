class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    @user = User.find(params[:format])
    @ratings = Rating.joins(:user).where("ratings.user_id = ?", @user.id).order(data: :desc)
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
    @user = User.find(params[:format])
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new(rating_params)
    @rating.data = DateTime.current
    @rating.driver_id = current_user.driver_id
    exist = Rating.where("user_id = ? and driver_id = ?", @rating.user_id, current_user.driver_id).exists?
    respond_to do |format|
      if !exist && @rating.save
        format.html { redirect_to ratings_path(@rating.user_id), notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      elsif exist
        format.html { redirect_to @rating, notice: error_one }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to @rating, notice: error_two }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  #def update
  #  respond_to do |format|
  #    if @rating.update(rating_params)
  #      format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @rating }
  #   else
  #      format.html { render :edit }
  #      format.json { render json: @rating.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
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
