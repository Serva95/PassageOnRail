class JourneysController < ApplicationController
  before_action :set_passenger_association, only: [:destroy]

  # POST /journey
  # POST /journey.json
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
      @journey = Journey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def passenger_association_params
      params.fetch(:journey, {})
    end
end
