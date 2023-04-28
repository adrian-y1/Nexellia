require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_user!
  before_action :set_current_user, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_notifications, :set_all_notifications

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
  end

  private

  def set_current_user
    Current.user = current_user
  end

  def set_unread_notifications
    return unless current_user
  
    @unread_notifications = current_user.notifications.unread.newest_first
    @unread_notifications_count = @unread_notifications.count
  end

  def set_all_notifications
    return unless current_user
    
    @all_notifications = current_user.notifications.newest_first
  end
end
