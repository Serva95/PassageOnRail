class RoutesController < ApplicationController
  before_action :get_driver, only: [:journey, :show, :edit, :update, :destroy, :new, :create]
  before_action :set_route, only: [:show, :edit, :destroy]

  # GET /routes
  # GET /routes.json
  def index
    @routes = Route.search(params[:search])
  end

  # GET /routes/booking
  def booking
    @route = Route.find(params[:id])
  end

  # GET /drivers/1/routes/journey
  def journey
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
        format.html { redirect_to journey_driver_routes_path(@driver), notice: 'Route was successfully created.' }
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
      if current_user.driver_id?
        @driver = Driver.find(params[:driver_id])

        if @route.update(route_params)
          format.html { redirect_to driver_route_path(@driver), notice: 'Route was successfully updated.' }
          format.json { render :show, status: :ok, location: @route }
        else
          format.html { render :edit }
          format.json { render json: @route.errors, status: :unprocessable_entity }
        end
      else
        n_passeggeri = params[:n_passeggeri]
        if @route.update(route_params)
          format.html { redirect_to driver_route_path(@driver), notice: 'Route was successfully updated.' }
          format.json { render :show, status: :ok, location: @route }
        else
          format.html { render :edit }
          format.json { render json: @route.errors, status: :unprocessable_entity }
        end

      end
    end
  end

  # DELETE /drivers/1/routes/1
  # DELETE /drivers/1/routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to journey_driver_routes_path(@driver), notice: 'Route was successfully destroyed.' }
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

end
