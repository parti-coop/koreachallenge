class StoriesController < ApplicationController
  def index
    @stories = Story.order_recent.page(params[:page]).per(6)
  end

  def show
    @story = Story.find(params[:id])
    @story.reads_count += 1
    @story.save
  end

  def new
    authorize Story.new
  end

  def create
    @story = Story.new story_params
    authorize @story

    @story.user = current_user

    ActiveRecord::Base.transaction do
      if @story.pin?
        Story.update_all(pin: false)
      end

      if @story.save
        flash[:success] = '게시되었습니다'
        redirect_to @story
      else
        errors_to_flash(@story)
        render :new
      end
    end
  end

  def edit
    @story = Story.find(params[:id])
    authorize @story
  end

  def update
    @story = Story.find(params[:id])
    authorize @story

    @story.assign_attributes(story_params)

    ActiveRecord::Base.transaction do
      if @story.pin?
        Story.update_all(pin: false)
      end

      if @story.save
        flash[:success] = '저장되었습니다'
        redirect_to @story
      else
        errors_to_flash(@story)
        render :new
      end
    end
  end

  def destroy
    @story = Story.find(params[:id])
    authorize @story

    if @story.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to stories_path
    else
      errors_to_flash(@story)
      redirect_to @story
    end
  end

  def remove_image
    @stroy = Story.find(params[:id])
    authorize @stroy, :update?
    @stroy.remove_image!
    if @stroy.save
      flash[:success] = '첨부파일이 삭제되었습니다.'
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
    end
    redirect_to edit_story_path(@story)
  end

  def remove_attachment
    @story = Story.find(params[:id])
    authorize @story, :update?
    @story.send(:"remove_attachment#{params[:index]}!")
    if @story.save
      flash[:success] = '첨부파일이 삭제되었습니다.'
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
    end
    redirect_to edit_story_path(@story)
  end

  private

  def story_params
    attributes = %i(title body image image_cache pin)
    (1..Story::ATTACHMENT_MAX_INDEX).each do |i|
      attributes += [:"attachment#{i}", :"attachment#{i}_cache"]
    end
    params.require(:story).permit(*attributes)
  end
end
