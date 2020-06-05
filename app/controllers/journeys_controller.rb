class JourneysController < ApplicationController
  before_action :set_journey, only: [:destroy]


  # GET /journeys/new
  def new
    @routes = Route.find(params[:ids])
    @seats = []
    @journey = Journey.new

    # vengono cercati i posti disponibili per le route selezionate
    # e vengono creati gli stage
    @routes.each do |route|
      @seats   << route.posti_disponibili
      @journey.stages.build(route_id: route.id)
    end

    # vengono estratti tutti i metodi di pagamento dell'utente
    # utilizzabili per le route selezionate
    @pay_methods = Route.find_pay_method(current_user.id, @routes)
  end

  # POST /journey
  def create
    # creo un oggetto journey che contiene anche gli stages associati
    @journey = Journey.new(journey_params)
    respond_to do |format|
      if @journey.booking
        # la prenotazione ha avuto successo, crea le notifiche
        @journey.stages.each do |stage|
          Notification.create_notifications_td(stage.route.driver_id, current_user, stage.route, @journey, "reservation")
        end
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
    render template: 'errors/deleted_route' if @route.deleted?
    @journey =  Journey.find(params[:id])
    @user = @journey.user
    @checked = ! Stage.already_checked(@route.id,@journey.id).nil?
  end

  #PATCH /routes/1/journeys/1
  def update_accept
    respond_to do |format|

      @route = Route.find(params[:route_id])
      @stage = @route.stages.where(journey_id: params[:id]).first
      @journey =  Journey.find(params[:id])

      if @stage.update(accepted: true)
        # crea la notifica una volta che la tratta è stata aggiornata correttamente
        Notification.create_notifications_th(@journey.user_id, current_user, @route, @route, "accept_trip")
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

      if @stage.reject(@journey.n_prenotati)
        # crea la notifica una volta che la tratta è stata aggiornata correttamente
        Notification.create_notifications_th(@journey.user_id, current_user, @route, @route, "reject_trip")
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @journey }
      else
        format.html { render :edit }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  def manage_booking_delete
    @deleted_route =Route.find(params[:target])
    @other_route = Route.find(params[:other])
    if @other_route.deleted.eql?('true') #se l'altra route è stata eliminata prima della lettura di questa notifica
      @both_deleted = true
    else
      @both_deleted = false
      @other_stage = Stage.where("route_id = ?",@other_route.id).first #se non lo trova è perchè entrambe sono state cancellate -> DA GESTIRE
    end
    @first=Route.first_route(@other_route,@deleted_route)
  end

  def manage_booking_update
    @updated_route =Route.find(params[:target])
    @other_route = Route.find(params[:other])
    @posti_updated = @updated_route.posti_disponibili
    @posti_other = @other_route.posti_disponibili
    if (@first=Route.first_route(@other_route,@updated_route))
      @overlying = Route.overlying(@other_route,@updated_route)
    else
      @overlying = Route.overlying(@updated_route,@other_route)
    end
    @updated_stage = Stage.where("route_id = ?",@updated_route.id).first
    @other_stage = Stage.where("route_id = ?",@other_route.id).first
    @journey_id = @other_stage.journey_id
  end

  # DELETE /journeys/1
  def destroy_temp
    route = Route.find(params[:r_id])
    is_deletable = Journey.journey_is_deletable(route)
    respond_to do |format|
      if is_deletable && Stage.delete_stage(@journey, route)
        Notification.create_notifications_td(route.driver_id, current_user, route, route, "cancel")
        format.html { redirect_to user_bookings_path(current_user.id), notice: 'Prenotazione eliminata' }
        format.json { head :no_content }
      else
        format.html { redirect_to detail_routes_path(multitrip: false, id: params[:r_id], j_id: params[:id]), notice: 'Errore eliminazione, non puoi annullare un viaggio se mancano meno di 48 ore alla partenza' }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /journeys/1
  # elimina entrambe gli stage
  def destroy
    route = []
    @journey.stages.sort_by { |x | x.route.data_ora_partenza  }.each do |stage|
      route << stage.route
    end
    notification = params[:notification]
    respond_to do |format|
      if Journey.delete_journey(@journey, route)
        route.each do |r|
          Notification.create_notifications_td(r.driver_id, current_user, r, r, "cancel")
        end
        if notification
          format.html { redirect_to new_search_path(c_part: route.first.citta_partenza, c_arr: route.last.citta_arrivo, data_ora: route.first.data_ora_partenza) }
          format.json { head :no_content }
        else
          format.html { redirect_to user_bookings_path(current_user.id), notice: 'Entrambe i viaggi della multitratta sono stati eliminati' }
          format.json { head :no_content }
        end
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
