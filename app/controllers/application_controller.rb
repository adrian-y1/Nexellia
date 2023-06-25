require "application_responder"

class ApplicationController < ActionController::Base
  include Pagy::Backend
  
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_user!
  before_action :set_current_user, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_notifications
  before_action :mark_as_read

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  def set_current_user
    Current.user = current_user
  end

  def set_notifications
    return unless current_user

    notifications = Notification.where(recipient: current_user).newest_first
    @all_notifications = notifications.includes(:recipient).limit(8)
    @unread_notifications = notifications.unread
  end

  def mark_as_read
    return unless params[:mark_as_read].present?
    
    Notification.where(recipient: current_user).mark_as_read!
    flash[:notice] = "Notifications have marked as read!"
  end
end
