class StagesController < ApplicationController
  before_action :set_multi_trip_association, only: [:show, :edit, :update, :destroy]

  # GET /multi_trip_associations
  # GET /multi_trip_associations.json
  def index
    @multi_trip_associations = MultiTripAssociation.all
  end

  # GET /multi_trip_associations/1
  # GET /multi_trip_associations/1.json
  def show
  end

  # GET /multi_trip_associations/new
  def new
    @multi_trip_association = MultiTripAssociation.new
  end

  # GET /multi_trip_associations/1/edit
  def edit
  end

  # POST /multi_trip_associations
  # POST /multi_trip_associations.json
  def create
    @multi_trip_association = MultiTripAssociation.new(multi_trip_association_params)

    respond_to do |format|
      if @multi_trip_association.save
        format.html { redirect_to @multi_trip_association, notice: 'Multi trip association was successfully created.' }
        format.json { render :show, status: :created, location: @multi_trip_association }
      else
        format.html { render :new }
        format.json { render json: @multi_trip_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /multi_trip_associations/1
  # PATCH/PUT /multi_trip_associations/1.json
  def update
    respond_to do |format|
      if @multi_trip_association.update(multi_trip_association_params)
        format.html { redirect_to @multi_trip_association, notice: 'Multi trip association was successfully updated.' }
        format.json { render :show, status: :ok, location: @multi_trip_association }
      else
        format.html { render :edit }
        format.json { render json: @multi_trip_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multi_trip_associations/1
  # DELETE /multi_trip_associations/1.json
  def destroy
    @multi_trip_association.destroy
    respond_to do |format|
      format.html { redirect_to multi_trip_associations_url, notice: 'Multi trip association was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_multi_trip_association
      @multi_trip_association = Stage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def multi_trip_association_params
      params.fetch(:stage, {})
    end
end
