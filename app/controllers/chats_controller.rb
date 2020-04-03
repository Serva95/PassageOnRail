class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /chats
  def index
    @chats = Chat.find_chats(current_user.id)
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # POST /chats
  def create
    #mettere notifiche, inserire opened at per entrambi gli user e notifica in pagina
    @chat = Chat.new(chat_params)
    @chat.user_1_id = current_user.id
    @chat.opened_at = DateTime.current
    @chat.updated_at = DateTime.current
    #mettere dentro una transaction self.transaction ??? cercare
    exists = Chat.exists(current_user.id, @chat.user_2_id)
    respond_to do |format|
      if exists.nil? && @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        #redirect alla chat se già esiste
        format.html { redirect_to chat_messagges_path(exists)}
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  #def destroy
  # @chat.destroy
  # respond_to do |format|
  #   format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
  #   format.json { head :no_content }
  # end
  #end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    #@chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:user_2_id)
  end
end
