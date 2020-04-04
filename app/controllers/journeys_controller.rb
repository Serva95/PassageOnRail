class JourneysController < ApplicationController
  before_action :set_passenger_association, only: [:destroy]

  # POST /journey
  # POST /journey.json
  def create
    @journey = Journey.new(journey_params)
    p = Route.sum_passengers(@journey.stages.route_id, params[:n_prenotati].to_i)
    respond_to do |format|
      if Journey.booking(@journey, p)
        format.html { redirect_to user_bookings(current_user.id), notice: 'Passenger association was successfully created.' }
        format.json { render :show, status: :created, location: @journey }
      else
        format.html { render :new }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /journeys/1
  # DELETE /journeys/1.json
  def destroy
    @passenger_association.destroy
    respond_to do |format|
      format.html { redirect_to passenger_associations_url, notice: 'Passenger association was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journey
      @journey = Journey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journey_params
      params.require(:journey).permit(:user_id, :n_prenotati, steges_attributes: [:id, :route_id, :journey_id])
    end

    def true?(obj)
      obj.to_s.downcase == "true"
    end
end
