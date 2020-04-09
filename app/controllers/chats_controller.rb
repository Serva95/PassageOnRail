class ChatsController < ApplicationController
  before_action :set_chat, only: [:destroy]

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
    @chat = Chat.new(chat_params)
    @chat.user_1_id = current_user.id
    current_datetime = DateTime.current
    @chat.open_time_user_1 = current_datetime
    @chat.open_time_user_2 = current_datetime - 30.minute
    @chat.updated_at = current_datetime - 1.hour
    exists = Chat.exists(current_user.id, @chat.user_2_id)
    respond_to do |format|
      if exists.nil? && @chat.save
        format.html { redirect_to chat_messagges_path(@chat) }
        format.json { render :show, status: :created, location: @chat }
      else
        #redirect alla chat se già esiste
        format.html { redirect_to chat_messagges_path(exists)}
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url }
      format.json { head :no_content }
    end
  end

  private
  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:user_2_id)
  end
end
