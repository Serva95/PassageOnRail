class StagesController < ApplicationController
  before_action :set_multi_trip_association, only: [:update, :destroy]

  # GET /multi_trip_associations
  def index
    @multi_trip_associations = MultiTripAssociation.all
  end

  # GET /multi_trip_associations/new
  def new
    @multi_trip_association = MultiTripAssociation.new
  end

  # POST /multi_trip_associations
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
  def destroy
    @multi_trip_association.destroy
    respond_to do |format|
      format.html { redirect_to multi_trip_associations_url, notice: 'Multi trip association was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_multi_trip_association
      @multi_trip_association = Stage.find(params[:id])
    end

    def multi_trip_association_params
      params.fetch(:stage, {})
    end
end
