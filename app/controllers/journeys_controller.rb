class JourneysController < ApplicationController
  before_action :set_journey, only: [:destroy]

  # POST /journey
  def create
    @journey = Journey.new(journey_params)
    # crea un nuovo journey e uno o due stage settando i parametri
    # passati dalla form
    respond_to do |format|
      if Journey.booking(@journey)
        format.html { redirect_to user_bookings_path(@journey.user_id), notice: 'Prenotazione creata' }
        format.json { render :show, status: :created, location: @journey }
      else
        format.html { render :new }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journeys/1
  # fare l'eliminazione del viaggio solo 48 ore prima, oppure sempre se ci sono modifiche da parte del guidatore
  def destroy
    is_deletable = Journey.journey_is_deletable(@journey.id)
    respond_to do |format|
      if is_deletable && @journey.destroy
        format.html { redirect_to user_bookings_path(@journey.user_id), notice: 'Prenotazione eliminata' }
        format.json { head :no_content }
      else
        format.html { redirect_to detail_routes_path(multitrip: false, id: params[:r_id], j_id: params[:id]), notice: 'Errore eliminazione, non puoi annullare un viaggio se mancano meno di 48 ore alla partenza' }
        format.json { head :no_content }
      end
    end
  end

  private
  def set_journey
    @journey = Journey.find(params[:id])
  end

  def journey_params
    params.require(:journey).permit(:user_id, :n_prenotati, stages_attributes: [:id, :route_id, :journey_id, :accepted])
  end

  def true?(obj)
    obj.to_s.downcase == "true"
  end
end
