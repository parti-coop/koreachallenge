class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  after_action :prepare_unobtrusive_flash
  before_action :prepare_meta_tags, if: -> { request.get? and !Rails.env.test? }

  include Pundit
  protect_from_forgery

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
    if user_signed_in?
      flash[:alert] = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
    else
      flash[:alert] = t("unsigned", scope: "pundit", default: :default)
    end
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

  private

  def prepare_meta_tags(options={})
    set_meta_tags build_meta_options(options)
  end

  def build_meta_options(options)
    unless options.nil?
      options.compact!
      options.reverse_merge! default_meta_options
    else
      options = default_meta_options
    end

    current_url = request.url
    og_description = (helpers.strip_tags options[:description]).truncate(160)
    {
      title:       options[:title],
      reverse:     true,
      image:       helpers.asset_url(options[:image]),
      description: options[:description],
      keywords:    options[:keywords],
      canonical:   current_url,
      og: {
        url: current_url,
        title: options[:og_title] || options[:title],
        image: helpers.asset_url(options[:image]),
        description: og_description,
        type: 'website'
      }
    }.reject{ |_,v| v.nil? }
  end

  def default_meta_options
    {
      title: "2019 코리아 챌린지 : 국민 제안, 국민 선택",
      description: "한국사회를 변화시킬 국민참여 아이디어 경연대회! 상금 1,919만원의 주인공이 되세요!",
      keywords: "삼일운동, 정치, 민주주의, 공론장",
      image: helpers.asset_url("kochal_seo.png"),
      twitter_card_type: "summary_card"
    }
  end
end
