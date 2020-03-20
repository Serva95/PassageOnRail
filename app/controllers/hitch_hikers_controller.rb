class HitchHikersController < ApplicationController
  before_action :set_hitch_hiker, only: [:show, :edit, :update, :destroy]

  # GET /hitch_hikers
  # GET /hitch_hikers.json
  def index
    redirect_to root_path
  end

  # GET /hitch_hikers/1
  # GET /hitch_hikers/1.json
  def show
    redirect_to user_path(current_user.id)
  end

  # GET /hitch_hikers/new
  def new
    redirect_to root_path
  end

  # GET /hitch_hikers/1/edit
  def edit
    redirect_to edit_user_path(current_user.id)
  end

  # POST /hitch_hikers
  # POST /hitch_hikers.json
  def create
    @hitch_hiker = HitchHiker.new(hitch_hiker_params)

    respond_to do |format|
      if @hitch_hiker.save
        format.html { redirect_to @hitch_hiker, notice: 'Hitch hiker was successfully created.' }
        format.json { render :show, status: :created, location: @hitch_hiker }
      else
        format.html { render :new }
        format.json { render json: @hitch_hiker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hitch_hikers/1
  # PATCH/PUT /hitch_hikers/1.json
  def update
    respond_to do |format|
      if @hitch_hiker.update(hitch_hiker_params)
        format.html { redirect_to @hitch_hiker, notice: 'Hitch hiker was successfully updated.' }
        format.json { render :show, status: :ok, location: @hitch_hiker }
      else
        format.html { render :edit }
        format.json { render json: @hitch_hiker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hitch_hikers/1
  # DELETE /hitch_hikers/1.json
  def destroy
    @hitch_hiker.destroy
    respond_to do |format|
      format.html { redirect_to hitch_hikers_url, notice: 'Hitch hiker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hitch_hiker
      @hitch_hiker = HitchHiker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hitch_hiker_params
      params.require(:hitch_hiker).permit(:rating_medio, :deleted, :email)
    end
end
