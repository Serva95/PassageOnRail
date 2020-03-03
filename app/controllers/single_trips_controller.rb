class SingleTripsController < ApplicationController
  before_action :set_single_trip, only: [:show, :edit, :update, :destroy]

  # GET /single_trips
  # GET /single_trips.json
  def index
    @single_trips = SingleTrip.all
  end

  # GET /single_trips/1
  # GET /single_trips/1.json
  def show
  end

  # GET /single_trips/new
  def new
    @single_trip = SingleTrip.new
  end

  # GET /single_trips/1/edit
  def edit
  end

  # POST /single_trips
  # POST /single_trips.json
  def create
    @single_trip = SingleTrip.new(single_trip_params)

    respond_to do |format|
      if @single_trip.save
        format.html { redirect_to @single_trip, notice: 'Single trip was successfully created.' }
        format.json { render :show, status: :created, location: @single_trip }
      else
        format.html { render :new }
        format.json { render json: @single_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /single_trips/1
  # PATCH/PUT /single_trips/1.json
  def update
    respond_to do |format|
      if @single_trip.update(single_trip_params)
        format.html { redirect_to @single_trip, notice: 'Single trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @single_trip }
      else
        format.html { render :edit }
        format.json { render json: @single_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /single_trips/1
  # DELETE /single_trips/1.json
  def destroy
    @single_trip.destroy
    respond_to do |format|
      format.html { redirect_to single_trips_url, notice: 'Single trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_single_trip
      @single_trip = SingleTrip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def single_trip_params
      params.require(:single_trip).permit(:n_passeggeri)
    end
end
