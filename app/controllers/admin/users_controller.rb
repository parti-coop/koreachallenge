class Admin::UsersController < AdminController
  def index
    @users = User.order_recent.page(params[:page]).per(50)
    if params[:q].present?
      query = params[:q]
      if query.present?
        @users = @users.search_for(query)
      end
    end
  end

  def add_admin
    @user = User.find(params[:id])
    @user.admin = true

    if @user.save
    else
      errors_to_flash(@user)
    end
    redirect_to admin_users_path(page: params[:page])
  end

  def remove_admin
    @user = User.find(params[:id])
    @user.admin = false

    if @user.save
    else
      errors_to_flash(@user)
    end
    redirect_to admin_users_path(page: params[:page])
  end
end
