class RoutesController < ApplicationController
  before_action :get_driver, only: [:journey, :index, :show, :edit, :destroy, :new, :create, :update, :booking]
  before_action :set_route, only: [:show, :edit, :destroy, :update]
  before_action :set_user, only: [:detail]

  # GET /routes/detail
  def detail
    @routes = Route.find(params[:ids])
    @drivers = []
    @seats = []
    @routes.each do |route|
      @drivers << route.driver.user
      @seats   << route.posti_disponibili
    end
  end

  # GET /drivers/1/routes
  def index
    @routes = @driver.routes.where("routes.deleted IS NOT TRUE")
  end

  # GET /drivers/1/routes/1
  def show
    @posti = @route.posti_disponibili
    @passengers = @route.find_passengers
    if @passengers.empty?
      @empty = true
    else
      @empty = false
    end
  end

  # GET /drivers/1/routes/new
  def new
    @route = @driver.routes.build
  end

  # GET /drivers/1/routes/1/edit
  def edit
  end

  # POST /drivers/1/routes
  def create
	  @route = @driver.routes.build(route_params)
    @route.data_ora_partenza = params[:data_partenza] + " " + params[:ora_partenza]
    @route.data_ora_arrivo = params[:data_arrivo] + " " + params[:ora_arrivo]
    @route.tempo_percorrenza = ((@route.data_ora_arrivo - @route.data_ora_partenza).to_i)/60
    respond_to do |format|
      if @route.save
        format.html { redirect_to driver_routes_path(@driver) }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new  }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1/routes/1
  def update
    respond_to do |format|
      @route.data_ora_partenza = params[:data_partenza] + " " + params[:ora_partenza]
      @route.data_ora_arrivo = params[:data_arrivo] + " " + params[:ora_arrivo]
      @route.tempo_percorrenza = ((@route.data_ora_arrivo - @route.data_ora_partenza).to_i)/60
      if @route.update(route_params)
        @journeys = Route.find_journeys(params[:id])
        @journeys.each {|journey|
          if  journey.stages.count == 1
            Journey.create_notifications_th(journey.user_id, current_user, @route, @route, "update_trip")
          else
            second_route = Route.find_second_stage(journey, @route.id)
            Journey.create_notifications_th(journey.user_id, current_user, @route, second_route, "update_multitrip")
          end
        }
        format.html { redirect_to driver_route_path(@driver) }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1/routes/1
  def destroy
    respond_to do |format|
      if Route.destroy_route_and_stages(@route,current_user)
        format.html { redirect_to driver_routes_path(@driver) }
        format.json { head :no_content }
      else
        format.html { redirect_to driver_routes_path(@driver) }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
      end
  end

  private
    def set_route
      @route = @driver.routes.find(params[:id])
      render template: 'errors/deleted_route' if @route.deleted?
    end

    def route_params
      params.require(:route).permit(:citta_partenza, :luogo_ritrovo, :data_ora_partenza, :citta_arrivo, :data_ora_arrivo, :costo, :deleted, :driver_id, :vehicle_id, :tempo_percorrenza, :n_passeggeri, :contanti)
    end

    def set_user
      @user = User.find(current_user.id)
    end

    def get_driver
      @driver = Driver.find(current_user.driver_id)
    end

  # trasforma un parametro da stringa a boolean
    def true?(obj)
      obj.to_s.downcase == "true"
    end

  def deleted?(obj)
    obj.deleted
  end

end
