class UsersController < ApplicationController
  # mostro la pagina dell'utente
  # GET /users/1
  # GET /users/1.json
  def show
      @user = User.find(params[:id])
  end

  # mostro tutte le route prenotate dall'utente loggato
  # GET /users/1/bookings
  def bookings
    @user=User.find(current_user.id)
    journeys=@user.find_bookings(current_user.id)
    #distinguo tra tratte ancora attive e tratte passate
    @journeys_active =[]
    @journeys_past = []
    j = 0
    i = 0
    journeys.each do |journey|
      unless journey.stages.first.accepted == false
        if journey.stages.first.route.data_ora_partenza >= Time.now
          @journeys_active[i] = journey
          i += 1
        else
          @journeys_past[j] = journey
          j += 1
        end
      end
    end
  end

  # mostro dettagli della tratta prenotata
  # GET /users/:id/bookings/:route_id
  def detail_booking
    begin
      @route=Route.find(params[:route_id])
      @journey_ok= Route.find_associated_stage(@route.id, current_user.id, params[:j_id])
      @driver=Route.find_driver(@route)
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "#{1.year.ago}"
    rescue ActiveRecord::RecordNotFound
      render :file => "#{Rails.root}/public/404.html", layout: true, status: :not_found
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :username, :password, :nome, :cognome, :data_di_nascita, :cellulare, :indirizzo, :url_foto, :deleted)
  end
end
