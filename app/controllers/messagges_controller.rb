class MessaggesController < ApplicationController
  #before_action :set_messagge, only: [:update]

  # GET /messagges
  def index
    if params[:limit].nil?
      @messagges = Messagge.find_messages(params[:chat_id], current_user.id, 15)
    else
      @messagges = Messagge.find_messages(params[:chat_id], current_user.id, nil)
    end

    if !@messagges.nil? && !@messagges.is_a?(String)
      Messagge.update_open_time(DateTime.current, params[:chat_id], current_user.id)
      @chatter = Messagge.find_chatters(params[:chat_id], current_user.id)
      @messagge = Messagge.new
    end
  end

  # POST /messagges
  def create
    @messagge = Messagge.new(messagge_params)
    @messagge.data_ora = DateTime.current
    @messagge.chat_id = params[:chat_id]
    @messagge.user_id = current_user.id
    @chat = Chat.find(params[:chat_id])
    infinite = params[:limit]
    respond_to do |format|
      if Messagge.new_msg_transaction(@messagge, @messagge.data_ora, @chat, current_user.id)
        @chatter = Messagge.find_chatters(@messagge.chat_id, current_user.id)
        if infinite.nil?
          format.html { redirect_to chat_messagges_path(params[:chat_id])}
        else
          format.html { redirect_to chat_messagges_path(params[:chat_id], limit: "infinite")}
        end
        format.json { render :index, status: :created, location: @messagge }
      else
        format.html { redirect_to chat_messagges_path(params[:chat_id]), notice: 'Messagge error' }
        format.json { render json: @messagge.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_messagge
    @messagge = Messagge.find(current_user.id)
  end

  def messagge_params
    params.require(:messagge).permit(:testo, :chat_id)
  end
end
