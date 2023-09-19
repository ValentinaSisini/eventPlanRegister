class ApplicationController < ActionController::Base
  # Aggiunta del campo "role" tra i campi permessi per l'Utente
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  # Customizzazione messaggio di Access Denied
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You do not have the necessary permissions to access this page."
    redirect_to root_path
  end

  # Aggiunta del menu
  helper_method :menu_options

  def menu_options
    [
      { name: 'Home', path: '/' },
      { name: 'Events', path: '/events' },
      { name: 'Partecipations', path: '/participations' },
      { name: 'Notifications', path: '/notifications' }
    ]
  end

end
