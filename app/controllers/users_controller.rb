class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
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
