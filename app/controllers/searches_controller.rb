class SearchesController < ApplicationController
  def new
    @search = Search.new
    if ((c_part = params['c_part']).present? && (c_arr = params['c_arr']).present? && (data_ora = params['data_ora']).present?)
      @c_part = c_part
      @c_arr = c_arr
      @data = data_ora.to_date
    end
  end

  def create
    @search = Search.new(search_params)
    if !params[:data].nil? && !params[:ora].nil?
      @search.data_ora = params[:data] + " " + params[:ora]
    elsif !params[:data].nil? && params[:ora].nil?
      @search.data_ora = params[:data] + " 00:00"
    elsif !params[:ora].nil? && params[:data].nil?
      @search.data_ora = Date.current + " " + params[:ora]
    end
    @search.save!
    redirect_to @search
  end

  # GET /seraches/46
  def show
    search = Search.find(params[:id])
    # cerca se esistono tratte dirette
    @booked_routes = search.already_booked(current_user.id)
    @single_search = search.search_routes(current_user.driver_id,@booked_routes)
    @empty_s = @single_search.empty?
    @hide = search.hide_multitrip
    @multi_search = search.multi_routes_search(current_user.driver_id,@booked_routes)
    @empty_m = @multi_search.empty?
  end

  private

  def search_params
    params.require(:search).permit(:c_partenza,:c_arrivo,:data_ora,:rating,:costo,:tipo_mezzo,:comfort,:sort_attribute,:sort_order,:multitrip)
  end
end
