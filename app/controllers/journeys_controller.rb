class JourneysController < ApplicationController
  before_action :set_journey, only: [:destroy]
  before_action :get_driver_journey, only: [:edit, :update]

  # POST /journey
  def create
    @journey = Journey.new(journey_params)
    # crea un nuovo journey e uno o due stage settando i parametri
    # passati dalla form
    respond_to do |format|
      if Journey.booking(@journey)
        # la prenotazione ha avuto successo, crea le notifiche
        Journey.create_notifications_td(@journey, current_user)
        format.html { redirect_to user_bookings_path(@journey.user_id), notice: 'Prenotazione creata' }
        format.json { render :show, status: :created, location: @journey }
      else
        format.html { render :new }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /drivers/1/journeys
  def index
    @journeys = Journey.find_requests(params[:driver_id])
  end

  #GET /drivers/1/journeys/1/edit?route_id = 14
  def edit
    @journeys = Journey.find_stage(params[:id], current_user.driver_id, params[:route])
    @journey = @journeys.first
    @journey.user

  end

  #PATCH /drivers/1/journeys/1/edit?route_id = 14
  def update
    respond_to do |format|
      if accepting?
        accept = true
      elsif refusing?
        accept = false
      end


      @journeys = Journey.find_stage(params[:id], current_user.driver_id, params[:journey][:stages_attributes]["0"][:route_id])
      @journey = @journeys.first
      @stage = @journey.stages.first

      if @stage.update(accepted: accept)
        if accepting?
          Journey.create_notifications_th(@journey, current_user, "accepted")
        elsif refusing?
          Journey.create_notifications_th(@journey, current_user, "rejected")
        end
        format.html { redirect_to root_path, notice: 'Journey was successfully updated.' }
        format.json { render :show, status: :ok, location: @journey }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /journeys/1
  # fare l'eliminazione del viaggio solo 48 ore prima, oppure sempre se ci sono modifiche da parte del guidatore
  def destroy
    route = Route.joins(:stages).where("journey_id = ?", @journey.id).first
    is_deletable = Journey.journey_is_deletable(route)
    respond_to do |format|
      if is_deletable && Journey.delete_passage_transaction(@journey, route)
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

  def get_driver_journey
    @driver = Driver.find(params[:driver_id])
  end

  def journey_params
    params.require(:journey).permit(:user_id, :n_prenotati, stages_attributes: [:id, :route_id, :journey_id, :accepted, :pay_method_id])
  end

  def true?(obj)
    obj.to_s.downcase == "true"
  end

  def accepting?
    params[:commit] == "Accetta"
  end

  def refusing?
    params[:commit] == "Rifiuta"
  end
end
