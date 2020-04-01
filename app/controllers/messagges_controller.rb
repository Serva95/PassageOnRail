class MessaggesController < ApplicationController
  before_action :set_messagge, only: [:show, :edit, :update, :destroy]

  # GET /messagges
  # GET /messagges.json
  def index
    #versione autostop che legge driver
    @messagges = Messagge.find_messages(params[:chat_id], current_user.id)
    if !@messagges.nil? && !@messagges.is_a?(String)
      @chatter = Messagge.find_chatters(params[:chat_id], current_user.id)
      @messagge = Messagge.new
    end
  end

  # GET /messagges/new
  #def new
  #  @messagge = Messagge.new
  #end

  # GET /messagges/1/edit
  #def edit
  #@messagges = Messagge.find(params[:id])
  #end

  # POST /messagges
  # POST /messagges.json
  def create
    @messagge = Messagge.new(messagge_params)
    @messagge.data_ora = DateTime.current
    @messagge.chat_id = params[:chat_id]
    @messagge.user_id = current_user.id
    @chat = Chat.find(params[:chat_id])
    respond_to do |format|
      if @messagge.save && @chat.update_column(:updated_at, DateTime.current)
        @chatter = Messagge.find_chatters(@messagge.chat_id, current_user.id)
        format.html { redirect_to chat_messagges_path(params[:chat_id]), notice: 'Messagge sent.' }
        format.json { render :index, status: :created, location: @messagge }
      else
        format.html { redirect_to chat_messagges_path(params[:chat_id]), notice: 'Messagge error' }
        format.json { render json: @messagge.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /messagges/1
  # PATCH/PUT /messagges/1.json
  #def update
  #respond_to do |format|
  #    if @messagge.update(messagge_params)
  #     format.html { redirect_to @messagge, notice: 'Messagge was successfully updated.' }
  #     format.json { render :show, status: :ok, location: @messagge }
  #   else
  #     format.html { render :edit }
  #     format.json { render json: @messagge.errors, status: :unprocessable_entity }
  #   end
  # end
  #end


  # DELETE /messagges/1
  # DELETE /messagges/1.json
  #def destroy
  #     @messagge.destroy
  #     respond_to do |format|
  #       format.html { redirect_to chats_path, notice: 'Messagge was successfully deleted.' }
  #       format.json { head :no_content }
  #     end
  #   end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_messagge
    @messagge = Messagge.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def messagge_params
    params.require(:messagge).permit(:data_ora, :testo, :chat_id, :user_id)
  end
end
