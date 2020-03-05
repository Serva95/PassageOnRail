class HomesController < ApplicationController

  def index
    @homes = Home.all
  end

end
