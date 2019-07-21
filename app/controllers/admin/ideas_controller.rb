class Admin::IdeasController < AdminController
  def index
    @ideas = Idea.all.order_recent.page(params[:page]).per(50)
  end

  def show
    @idea = Idea.find(params[:id])
  end
end
