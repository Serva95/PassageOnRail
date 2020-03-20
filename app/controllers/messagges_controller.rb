class MessaggesController < ApplicationController
  before_action :set_messagge, only: [:show, :edit, :update, :destroy]

  # GET /messagges
  # GET /messagges.json
  def index
    #versione autostop che legge driver
    @messagges = Messagge.joins(:user).where("chat_id = ?", params[:chat_id])
    if !@messagges.present? && @messagges[0].user_id != current_user.id
      @chatter_name = @messagges[0].nome
      @chatter_surn = @messagges[0].cognome
    else
      #@chatter = Chat.joins(:user_1, :user_2).where("chats.id = ?", params[:chat_id]).limit(1).select(:nome, :cognome).first
    end
  end

  # GET /messagges/1
  # GET /messagges/1.json
  def show
  end



  # GET /messagges/new
  def new
    @messagge = Messagge.new
  end

  # GET /messagges/1/edit
  def edit
    @messagges = Messagge.find(params[:id])
  end

  # POST /messagges
  # POST /messagges.json
  def create
    @messagge = Messagge.new(messagge_params)
    @messagge.data_ora = DateTime.current
    respond_to do |format|
      if @messagge.save
        format.html { redirect_to @messagge, notice: 'Messagge was successfully created.' }
        format.json { render :show, status: :created, location: @messagge }
      else
        format.html { render :new }
        format.json { render json: @messagge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messagges/1
  # PATCH/PUT /messagges/1.json
  def update
    respond_to do |format|
      if @messagge.update(messagge_params)
        format.html { redirect_to @messagge, notice: 'Messagge was successfully updated.' }
        format.json { render :show, status: :ok, location: @messagge }
      else
        format.html { render :edit }
        format.json { render json: @messagge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messagges/1
  # DELETE /messagges/1.json
  def destroy
    @messagge.destroy
    respond_to do |format|
      format.html { redirect_to messagges_url, notice: 'Messagge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_messagge
      @messagge = Messagge.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def messagge_params
      params.require(:messagge).permit(:data_ora, :testo, :mittente, :destinatario, :deleted)
    end
end
