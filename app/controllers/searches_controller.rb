class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.create(search_params)
    redirect_to @search
  end

  # GET /seraches/46
  def show
    search = Search.find(params[:id])
    # cerca se esistono tratte dirette
    @single_search = search.search_routes
    @hide = search.hide_multitrip
    @multi_search = search.multi_routes_search
  end


  private

  def search_params
    params.require(:search).permit(:c_partenza,:c_arrivo,:data_ora,:rating,:costo,:tipo_mezzo,:comfort,:sort_attribute,:sort_order,:multitrip)
  end
end
