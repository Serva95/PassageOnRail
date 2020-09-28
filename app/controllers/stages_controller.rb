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

  # DELETE /stages/1
  def destroy
    route = Route.find(params[:r_id])
    is_deletable = Journey.journey_is_deletable(route)
    journey = Journey.find(params[:j_id])
    notification = params[:notification]
    respond_to do |format|
      if is_deletable && Stage.delete_stage(journey, route)
        Notification.where(target: route, second_target: journey).update_all(read_at: Time.zone.now)
        Notification.create_notifications_td(route.driver_id, current_user, route, route, "cancel")
        if notification
          format.html { redirect_to new_search_path(c_part: params[:c_part],c_arr: params[:c_arr],data_ora: params[:data]), notice: 'Prenotazione eliminata' }
          format.json { head :no_content }
        else
          format.html { redirect_to user_bookings_path(current_user.id), notice: 'Prenotazione eliminata' }
        end
      else
        format.html { redirect_to user_detail_booking_path(current_user,j_id: params[:j_id]), notice: 'Errore eliminazione, non puoi annullare un viaggio se mancano meno di 48 ore alla partenza' }
      end
    end
  end

  private
  def set_stage
    @stage = Stage.find(params[:id])
  end

  def get_driver_journey
    @driver = Driver.find(current_user.driver_id)
  end

  def stage_params
    params.require(:stage).permit(:id, :route_id, :journey_id, :accepted, :pay_method_id)
  end


end
