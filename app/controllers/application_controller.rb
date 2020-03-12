class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :nome, :cognome, :indirizzo, :data_di_nascita,
                                                       :cellulare, :url_foto])
  end
end