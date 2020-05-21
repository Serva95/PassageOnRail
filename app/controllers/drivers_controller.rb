class DriversController < ApplicationController
  before_action :set_driver, only: [ :edit, :update, :destroy]

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new
    respond_to do |format|
      if @driver.save
        current_user.update_attributes(driver_id: @driver.id)
        format.html { redirect_to new_driver_vehicle_path(current_user.driver_id) , notice: 'Driver was successfully created.' }
        format.json { render :confirm_destroy, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :confirm_destroy, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET
  def confirm_destroy
    @driver= Driver.find(current_user.driver_id)
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    current_user.update_attributes(driver_id: nil)
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def driver_params
    params.require(:driver).permit(:rating_medio, :deleted, :email)
    end
end
