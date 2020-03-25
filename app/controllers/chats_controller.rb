class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /chats
  # GET /chats.json
  def index
    @chats = Chat.find_chats(current_user.id)
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
    @messagge = Messagge.where()
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)
    @chat.user_1_id = current_user.id
    exists = Chat.exists(current_user.id, @chat.user_2_id)
    respond_to do |format|
      if exists.nil? && @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        #redirect alla chat se già esiste
        format.html { redirect_to chat_messagges_path(exists)}

        #eventuale errore da far vedere nella pagina con le chat
        #format.html { render :index }
        #@chat_message = "Errore, chat già esistente"
        #@chats = Chat.find_chats(current_user.id)
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: 'Chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      #@chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:user_2_id)
    end
end
