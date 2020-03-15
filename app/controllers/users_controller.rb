class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    redirect_to root_path
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    redirect_to root_path
  end

  # GET /users/1/edit
  def edit
    redirect_to root_path
  end

  # POST /users
  # POST /users.json
  def create
    redirect_to root_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    redirect_to root_path
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
   redirect_to root_path
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
