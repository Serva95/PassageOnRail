class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # mostro la pagina dell'utente
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # mostro tutte le route prenotate dall'utente loggato
  # GET /users/1/bookings
  def bookings
    @user=User.find(params[:id])
    journeys=@user.find_bookings(current_user.id)
    #distinguo tra tratte ancora attive e tratte passate
    @journeys_active =[]
    @journeys_past = []
    j = 0
    i = 0
    journeys.each do |journey|
      if journey.stages.first.route.data_ora_partenza >= Time.now
        @journeys_active[i] = journey
        i += 1
      else
        @journeys_past[j] = journey
        j += 1
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :username, :password, :nome, :cognome, :data_di_nascita, :cellulare, :indirizzo, :url_foto, :deleted)
    end
end
