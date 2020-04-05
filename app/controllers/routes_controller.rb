class RoutesController < ApplicationController
  before_action :get_driver, only: [:journey, :index, :show, :edit, :destroy, :new, :create, :update, :booking]
  before_action :set_route, only: [:show, :edit, :destroy, :update]


  # GET /routes/detail
  def detail
    @multi_trip = true?(params[:multitrip])
    if @multi_trip
      # se si richiedono i dettagli di un viaggio con due tratte
      @route1 = Route.find(params[:id1])
      @route2 = Route.find(params[:id2])
      # cerca le due tratte

      @posti1 = Route.posti_disponibili(params[:id1], @route1.vehicle_id)
      @posti2 = Route.posti_disponibili(params[:id2], @route2.vehicle_id)
      # cerchi i posti disponibili per ciascuna tratta

      @journey = Journey.new
      @journey.stages.build(route_id: @route1.id)
      @journey.stages.build(route_id: @route2.id)
      # crea gli oggetti per la form
    else
      # se si richiedono i dettagli di un viaggio con tratta diretta
      @route = Route.find(params[:id])
      # cerca la tratta
      @posti = Route.posti_disponibili(params[:id], @route.vehicle_id)
      # cerca i posti disponibili
      @journey = Journey.new
      @journey.stages.build(route_id: @route.id)
      # crea gli oggetti per il form
      @booked_route = Route.already_booked(params[:id],current_user.id).empty?
      # controllo se la route è stata già prenotata
    end
  end

  # GET /drivers/1/routes
  # GET /drivers/1/routes.json
  def index
    @routes = @driver.routes
  end

  # GET /drivers/1/routes/1
  # GET /drivers/1/routes/1.json
  def show
    @route = @driver.routes.find(params[:id])
  end

  # GET /drivers/1/routes/new
  def new
    @route = @driver.routes.build
  end

  # GET /drivers/1/routes/1/edit
  def edit
  end

  # POST /drivers/1/routes
  # POST /drivers/1/routes.json
  def create
	  @route = @driver.routes.build(route_params)
    #@route.n_passeggeri = 0

    respond_to do |format|
      if @route.save
        format.html { redirect_to driver_routes_path(@driver), notice: 'Route was successfully created.' }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new  }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1/routes/1
  # PATCH/PUT /drivers/1/routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html { redirect_to driver_route_path(@driver), notice: 'Route was successfully updated.' }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1/routes/1
  # DELETE /drivers/1/routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to driver_routes_path(@driver), notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = @driver.routes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def route_params
      params.require(:route).permit(:citta_partenza, :luogo_ritrovo, :data_ora_partenza, :citta_arrivo, :data_ora_arrivo, :costo, :deleted, :driver_id, :vehicle_id, :tempo_percorrenza, :n_passeggeri)
      end

    def get_driver
      @driver = Driver.find(params[:driver_id])
    end

  # trasforma un parametro da stringa a boolean
    def true?(obj)
      obj.to_s.downcase == "true"
    end

end
