class ErrorsController < ApplicationController
  
  def not_found
  #   raise ActionController::RoutingError.new('Not Found')
  # rescue
  # # ignored
  end

  def record_not_found

  end

  def internal_server_error
  #   raise ActionView::Template::Error
  # rescue
  #   # ignored
  end

end