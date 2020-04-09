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
    @booked_routes = search.already_booked(current_user.id)
    @single_search = search.search_routes(current_user,@booked_routes)
    @empty_s = @single_search.empty?
    @hide = search.hide_multitrip
    @multi_search = search.multi_routes_search(current_user,@booked_routes)
    @empty_m = @multi_search.empty?
  end


  private

  def search_params
    params.require(:search).permit(:c_partenza,:c_arrivo,:data_ora,:rating,:costo,:tipo_mezzo,:comfort,:sort_attribute,:sort_order,:multitrip)
  end
end
