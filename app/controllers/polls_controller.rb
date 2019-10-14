class PollsController < ApplicationController
  def index
    @polls = Poll.order_recent
  end

  def show
    @poll = Poll.find(params[:id])
    @poll.reads_count += 1
    @poll.save
    prepare_meta_tags description: HTMLEntities.new.decode(ActionView::Base.full_sanitizer.sanitize(@poll.body)),
                      image: @poll.image.url(:md)
  end

  def new
    authorize Poll.new
  end

  def create
    @poll = Poll.new poll_params
    authorize @poll

    @poll.user = current_user

    ActiveRecord::Base.transaction do
      if @poll.save
        flash[:success] = '게시되었습니다'
        redirect_to @poll
      else
        errors_to_flash(@poll)
        render :new
      end
    end
  end

  def edit
    @poll = Poll.find(params[:id])
    authorize @poll
  end

  def update
    @poll = Poll.find(params[:id])
    authorize @poll

    @poll.assign_attributes(poll_params)

    ActiveRecord::Base.transaction do
      if @poll.save
        flash[:success] = '저장되었습니다'
        redirect_to @poll
      else
        errors_to_flash(@poll)
        render :new
      end
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    authorize @poll

    if @poll.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to stories_path
    else
      errors_to_flash(@poll)
      redirect_to @poll
    end
  end

  def remove_image
    @poll = Poll.find(params[:id])
    authorize @poll, :update?
    @poll.remove_image!
    if @poll.save
      flash[:success] = '첨부파일이 삭제되었습니다.'
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
    end
    redirect_to edit_poll_path(@poll)
  end

  def remove_attachment
    @poll = Poll.find(params[:id])
    authorize @poll, :update?
    @poll.send(:"remove_attachment#{params[:index]}!")
    if @poll.save
      flash[:success] = '첨부파일이 삭제되었습니다.'
    else
      flash[:error] = '앗! 뭔가 잘못되었습니다. 잠시 후에 다시 시도해 주세요.'
    end
    redirect_to edit_poll_path(@poll)
  end

  def download_attachment
    @poll = Poll.find(params[:id])
    render_404 and return if params[:index].blank?
    
    attachment = @poll.send(:"attachment#{params[:index]}")
    # local storage
    send_file(attachment.path,
      filename: encoded_attachment_name(@poll, params[:index]),
      type: @poll.send(:"attachment#{params[:index]}_type"),
      disposition: 'attachment')
  end

  private

  def poll_params
    attributes = %i(title body image image_cache)
    (1..Story::ATTACHMENT_MAX_INDEX).each do |i|
      attributes += [:"attachment#{i}", :"attachment#{i}_cache"]
    end
    params.require(:poll).permit(*attributes)
  end

  def encoded_attachment_name poll, index
    filename = poll.valid_attachment_name(index)
    if browser.edge?
      filename = CGI::escape(filename)
    elsif browser.ie? 
      filename = URI::encode(filename)
    elsif ENV['FILENAME_ENCODING'].present?
      filename = filename.encode('UTF-8', ENV['FILENAME_ENCODING'], invalid: :replace, undef: :replace, replace: '?')
    end
    filename
  end
end
