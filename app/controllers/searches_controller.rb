class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.create(search_params)
    redirect_to @search
  end

  def show
    @search = Search.find(params[:id])
  end


  private

  def search_params
    params.require(:search).permit(:c_partenza,:c_arrivo,:data_ora,:rating,:costo,:tipo_mezzo,:comfort)
  end
end
