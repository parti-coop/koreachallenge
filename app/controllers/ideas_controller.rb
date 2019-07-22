class IdeasController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  def new
    @idea = current_user.try(:idea)
    @idea = Idea.new(mode: :solo) if @idea.blank?
    authorize @idea
  end

  def create
    @idea = Idea.new(idea_params)
    authorize @idea
    @idea.user = current_user
    unless temporary_save?
      @idea.submitted_at = DateTime.current
    end
    if @idea.save
      flash[:success] = @idea.submitted? ? '제출되었습니다.' : '임시저장되었습니다.'
      if continue_edit?
        redirect_to new_idea_path(@idea, continue_edit: :ok)
      else
        redirect_to root_path
      end
    else
      errors_to_flash(@idea)
      render 'new'
    end
  end

  def update
    @idea = Idea.find(params[:id])
    authorize @idea
    @idea.assign_attributes(idea_params)
    if temporary_save?
      @idea.submitted_at = nil
    else
      @idea.submitted_at = DateTime.current
    end
    if @idea.save
      flash[:success] = @idea.submitted? ? '제출되었습니다.' : '임시저장되었습니다.'
      if continue_edit?
        redirect_to new_idea_path(@idea, continue_edit: :ok)
      else
        redirect_to root_path
      end
    else
      errors_to_flash(@idea)
      render 'new'
    end
  end

  def destory
    @idea = Idea.find(params[:id])
    authorize @idea
    if @idea.destory
      flash[:success] = '참가신청서가 삭제되었습니다.'
      redirect_to root_path
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
      redirect_to new_idea_path
    end
  end

  def download_attachment
    @idea = Idea.find(params[:id])
    authorize @idea, :update?
    # local storage
    send_file(@idea.attachment.path,
      filename: encoded_attachment_name(@idea),
      type: @idea.attachment_type,
      disposition: 'attachment')
  end

  def remove_attachment
    @idea = Idea.find(params[:id])
    authorize @idea, :update?
    @idea.remove_attachment!
    if @idea.save
      flash[:success] = '첨부파일이 삭제되었습니다.'
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
    end
    redirect_to new_idea_path
  end

  private

  def idea_params
    params.require(:idea).permit(:category, :title,
      :mode, :team_name, :motivation, :summary, :pt, :desc, :attachment,
      members_attributes: [:id, :name, :age, :sex, :org, :address, :tel, :email, :_destroy])
  end

  def temporary_save?
    return false if %w(수정하기 제출하기).include?(params[:commit])
    return true if %w(제출취소 임시저장).include?(params[:commit])
  end

  def encoded_attachment_name idea
    filename = idea.valid_attachment_name
    if browser.ie?
      filename = URI::encode(filename)
    elsif ENV['FILENAME_ENCODING'].present?
      filename = filename.encode('UTF-8', ENV['FILENAME_ENCODING'], invalid: :replace, undef: :replace, replace: '?')
    end
    filename
  end

  def continue_edit?
    cookies['idea-form-continue'] == 'true'
  end
end