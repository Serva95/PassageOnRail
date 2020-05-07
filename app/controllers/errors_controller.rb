class ErrorsController < ApplicationController
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def record_not_found
    raise ActiveRecord::RecordNotFound
  rescue
    render file: "#{Rails.root}/public/442", status: 442
  end

end