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
      if exists.nil? && @chat.save!
        format.html { redirect_to chat_messagges_path(@chat) }
        format.json { render :show, status: :created, location: @chat }
      elsif !exists.nil?
        if exists.deleted_user_1 && exists.user_1_id == current_user.id && Chat.delete_reset_side(exists, 1, false)
          exists.deleted_user_1 = false
          #redirect alla chat se già esiste
          format.html { redirect_to chat_messagges_path(exists)}
          format.json { render json: @chat.errors, status: :unprocessable_entity }
        elsif exists.deleted_user_2 && exists.user_2_id == current_user.id && Chat.delete_reset_side(exists, 2, false)
          exists.deleted_user_2 = false
          #redirect alla chat se già esiste
          format.html { redirect_to chat_messagges_path(exists)}
          format.json { render json: @chat.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to chat_messagges_path(exists)}
          format.json { render json: @chat.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to chats_path, notice: "Errore nella creazione" }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /chats/1
  # fare la destroy per ogni lato della chat
  def destroy
    if @chat.deleted_user_1 || @chat.deleted_user_2
      respond_to do |format|
        #controlli di sicurezza affinché solo l'utente attuale può eliminare la sua chat
        if @chat.user_1_id == current_user.id && @chat.destroy!
          format.html { redirect_to chats_path, notice: "Chat eliminata correttamente" }
          format.json { head :no_content }
        elsif @chat.user_2_id == current_user.id && @chat.destroy!
          format.html { redirect_to chats_path, notice: "Chat eliminata correttamente" }
          format.json { head :no_content }
        else
          format.html { redirect_to chats_path, notice: "Errore nell'eliminazione" }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        #controlli di sicurezza affinché solo l'utente attuale può eliminare "il suo lato" della chat
        if @chat.user_1_id == current_user.id && Chat.delete_reset_side(@chat, 1, true)
          format.html { redirect_to chats_path, notice: "Chat eliminata correttamente" }
          format.json { head :no_content }
        elsif @chat.user_2_id == current_user.id && Chat.delete_reset_side(@chat, 2, true)
          format.html { redirect_to chats_path, notice: "Chat eliminata correttamente" }
          format.json { head :no_content }
        else
          format.html { redirect_to chats_path, notice: "Errore nell'eliminazione" }
          format.json { head :no_content }
        end
      end
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
