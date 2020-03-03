class MultiTripsController < ApplicationController
  before_action :set_multi_trip, only: [:show, :edit, :update, :destroy]

  # GET /multi_trips
  # GET /multi_trips.json
  def index
    @multi_trips = MultiTrip.all
  end

  # GET /multi_trips/1
  # GET /multi_trips/1.json
  def show
  end

  # GET /multi_trips/new
  def new
    @multi_trip = MultiTrip.new
  end

  # GET /multi_trips/1/edit
  def edit
  end

  # POST /multi_trips
  # POST /multi_trips.json
  def create
    @multi_trip = MultiTrip.new(multi_trip_params)

    respond_to do |format|
      if @multi_trip.save
        format.html { redirect_to @multi_trip, notice: 'Multi trip was successfully created.' }
        format.json { render :show, status: :created, location: @multi_trip }
      else
        format.html { render :new }
        format.json { render json: @multi_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /multi_trips/1
  # PATCH/PUT /multi_trips/1.json
  def update
    respond_to do |format|
      if @multi_trip.update(multi_trip_params)
        format.html { redirect_to @multi_trip, notice: 'Multi trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @multi_trip }
      else
        format.html { render :edit }
        format.json { render json: @multi_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multi_trips/1
  # DELETE /multi_trips/1.json
  def destroy
    @multi_trip.destroy
    respond_to do |format|
      format.html { redirect_to multi_trips_url, notice: 'Multi trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_multi_trip
      @multi_trip = MultiTrip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def multi_trip_params
      params.require(:multi_trip).permit(:data_ora_partenza, :citta_partenza, :data_ora_arrivo, :citta_arrivo, :costo_totale, :comfort_medio, :numero_cambi)
    end
end
