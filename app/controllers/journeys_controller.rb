class JourneysController < ApplicationController
  before_action :set_passenger_association, only: [:show, :edit, :update, :destroy]

  # GET /journey
  # GET /journey.json
  def index
    @journeys = Journey.all
  end

  # GET /journeys/1
  # GET /journeys/1.json
  def show
  end

  # GET /passenger_associations/new
  def new
    @journey = Journey.new
  end

  # GET /passenger_associations/1/edit
  def edit
  end

  # POST /passenger_associations
  # POST /passenger_associations.json
  def create
    @passenger_association = Path.new(passenger_association_params)

    respond_to do |format|
      if @passenger_association.save
        format.html { redirect_to @passenger_association, notice: 'Passenger association was successfully created.' }
        format.json { render :show, status: :created, location: @passenger_association }
      else
        format.html { render :new }
        format.json { render json: @passenger_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /passenger_associations/1
  # PATCH/PUT /passenger_associations/1.json
  def update
    respond_to do |format|
      if @passenger_association.update(passenger_association_params)
        format.html { redirect_to @passenger_association, notice: 'Passenger association was successfully updated.' }
        format.json { render :show, status: :ok, location: @passenger_association }
      else
        format.html { render :edit }
        format.json { render json: @passenger_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passenger_associations/1
  # DELETE /passenger_associations/1.json
  def destroy
    @passenger_association.destroy
    respond_to do |format|
      format.html { redirect_to passenger_associations_url, notice: 'Passenger association was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_passenger_association
      @passenger_association = Journey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def passenger_association_params
      params.fetch(:journey, {})
    end
end
