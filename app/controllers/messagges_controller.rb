class MessaggesController < ApplicationController
  before_action :set_messagge, only: [:show, :edit, :update, :destroy]

  # GET /messagges
  # GET /messagges.json
  def index
    @messagges = Messagge.all
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
  end

  # POST /messagges
  # POST /messagges.json
  def create
    @messagge = Messagge.new(messagge_params)

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
      params.require(:messagge).permit(:data_ora, :testo, :mittente, :destinatario)
    end
end
