class Admin::IdeasController < AdminController
  def index
    @ideas = Idea.all.order_recent.page(params[:page]).per(50)
  end

  def show
    @idea = Idea.find(params[:id])
    respond_to do |format|
      format.xlsx {
        file_name = "#{@idea.user.name}.xlsx"
        if browser.ie?
          file_name = URI::encode(file_name)
        end
        response.headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
      }
      format.html
   end
  end
end
