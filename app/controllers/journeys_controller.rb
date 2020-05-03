class JourneysController < ApplicationController
  before_action :set_journey, only: [:destroy]


  # POST /journey
  def create
    @journey = Journey.new(journey_params)
    # crea un nuovo journey e uno o due stage settando i parametri
    # passati dalla form
    respond_to do |format|
      if Journey.booking(@journey)
        # la prenotazione ha avuto successo, crea le notifiche
        Journey.create_notifications_td(@journey, current_user,"reservation")
        format.html { redirect_to user_bookings_path(current_user.id), notice: 'Prenotazione creata' }
        format.json { render :show, status: :created, location: @journey }
      else
        format.html { render :new }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /drivers/1/journeys
  def index
    # trova tutte le richieste che hanno accepted = nil
    @journeys = Journey.find_requests(current_user.driver_id)
  end

  #GET /routes/1/journeys/1/edit
  def edit
    @route = Route.find(params[:route_id])
    @journey =  Journey.find(params[:id])
    @user = @journey.user
    @checked = Journey.already_checked(@route.id,@journey.id)
  end

  #PATCH /routes/1/journeys/1
  def update_accept
    respond_to do |format|

      @route = Route.find(params[:route_id])
      @stage = @route.stages.where(journey_id: params[:id]).first
      @journey =  Journey.find(params[:id])

      if @stage.update(accepted: true)
        # crea la notifica una volta che la tratta è stata aggiornata correttamente
        byebug
        Journey.create_notifications_th(@journey, current_user, "accepted")
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @journey }
      else
        format.html { render :edit }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_reject
    respond_to do |format|
      @route = Route.find(params[:route_id])
      @stage = @route.stages.where(journey_id: params[:id]).first
      @journey =  Journey.find(params[:id])

      if Journey.reject(@journey.n_prenotati, @stage)
        # crea la notifica una volta che la tratta è stata aggiornata correttamente
        byebug
        Journey.create_notifications_th(@journey, current_user, "rejected")
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @journey }
      else
        format.html { render :edit }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  def manage_booking
    if params[:type].eql?("delete_multitrip")
      @delete=true
    else
      @delete=false
    end
    @target_route =Route.find(params[:target])
    @other_route = Route.find(params[:other])
    @other_stage = Stage.where("route_id = ?",@other_route.id).first #se non lo trova è perchè entrambe sono state cancellate -> DA GESTIRE
    @first=Route.first_route(@other_route,@target_route)
  end

  # DELETE /journeys/1
  def destroy
    route = Route.find(params[:r_id])
    is_deletable = Journey.journey_is_deletable(route)
    respond_to do |format|
      if is_deletable && Journey.delete_passage_transaction(@journey, route, current_user)
        format.html { redirect_to user_bookings_path(current_user.id), notice: 'Prenotazione eliminata' }
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
    @driver = Driver.find(current_user.driver_id)
  end

  def journey_params
    params.require(:journey).permit(:user_id, :n_prenotati, :pay_method_id, stages_attributes: [:id, :route_id, :journey_id, :accepted])
  end

  def true?(obj)
    obj.to_s.downcase == "true"
  end
end
