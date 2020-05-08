class ErrorsController < ApplicationController


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
  # ignored
  end

  def record_not_found
    raise ActiveRecord::RecordNotFound
  rescue
    # ignored
  end


end