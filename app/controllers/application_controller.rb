class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  after_action :prepare_unobtrusive_flash

  include Pundit

  layout -> { get_layout }

  def get_layout
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def errors_to_flash(model)
    return if model.errors.empty?
    result ||= ""
    result += model.errors.full_messages.join('<br>')
    flash[:notice] = result.html_safe
  end

  if Rails.env.production? or Rails.env.staging?
    rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, ActionController::UnknownFormat do |exception|
      render_404
    end
    rescue_from ActionController::InvalidCrossOriginRequest, ActionController::InvalidAuthenticityToken do |exception|
      render_403
    end
  end
  rescue_from Pundit::NotAuthorizedError do |exception|
    policy_name = exception.policy.class.to_s.underscore
    flash[:alert] = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
    render_401
  end

  def render_401
    self.response_body = nil
    respond_to do |format|
      format.html { redirect_to error_401_path }
      format.js { head 401 }
    end
  end

  def render_403
    self.response_body = nil
    respond_to do |format|
      format.html { redirect_to error_403_path }
      format.js { head 403 }
    end
  end


  def render_404
    self.response_body = nil
    respond_to do |format|
      format.html { redirect_to error_404_path }
      format.js { head 404 }
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def storable_location?
    request.get? and is_navigational_format? and !devise_controller? and
      !request.xhr? and controller_name != 'errors' and
      !devise_controller? and
      !(controller_name == 'users' and action_name == 'confirm') and
      !(controller_name == 'users' and action_name == 'confirm_form') and
      !(controller_name == 'users' and action_name == 'cancel')
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
