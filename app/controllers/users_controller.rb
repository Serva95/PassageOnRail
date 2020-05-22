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
    journeys.each do |journey|
      unless journey.stages.first.accepted == false
        if journey.stages.first.route.data_ora_partenza >= Time.now
          @journeys_active << journey
        else
          @journeys_past << journey
        end
      end
    end
  end

  # mostro dettagli della tratta prenotata
  # GET /users/:id/bookings/detail
  def detail_booking
    begin
      @journey = Journey.find(params[:j_id])
      @routes = []
      @ute_drivers = []
      @journey.stages.each do |stage|
        @routes << stage.route
        @ute_drivers << stage.route.driver.user
      end
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "#{1.year.ago}"
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :username, :password, :nome, :cognome, :data_di_nascita, :cellulare, :indirizzo, :url_foto, :deleted)
  end
end
