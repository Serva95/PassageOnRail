class StagesController < ApplicationController
  before_action :set_stage, only: [:update]
  before_action :get_driver, only: [:update]

  # PATCH/PUT /drivers/1/stages/1
  def update
    respond_to do |format|
      if accepting?
        accept = true
      elsif refusing?
        accept = false
      end

      if @stage.update(stage_params, stages: {accepted: accept })

        if accepting?
          Journey.create_notifications_th(@journey, current_user, "accepted")
        elsif refusing?
          Journey.create_notifications_th(@journey, current_user, "rejected")
        end

        format.html { redirect_to root_path, notice: 'ottimo' }
        format.json { render :show, status: :ok, location: @stage }
      else
        format.html { render :edit }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_stage
      @stage = Stage.find(params[:id])
    end

    def get_driver_journey
      @driver = Driver.find(params[:driver_id])
    end

    def stage_params
      params.require(:stage).permit(:id, :route_id, :journey_id, :accepted, :pay_method_id)
    end


end
