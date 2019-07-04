class AdminController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    if !user_signed_in? or !current_user.admin?
      render_403 and return
    end
  end
end
