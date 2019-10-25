class GalleriesController < ApplicationController

  respond_to :html, :json

  def index
    round_slug = params[:round_slug] || Gallery::DEFALUT_ROUND_SLUG
    @galleries = Gallery.order_recent.for_round_slug(round_slug).page(params[:page])

    if params[:gallery_id].present?
      @gallery = Gallery.find_by(id: params[:gallery_id])
    end
  end

  def show
    @gallery = Gallery.find(params[:id])
    @gallery.reads_count += 1
    @gallery.save

    respond_modal_with @gallery
  end

  def new
    authorize Gallery.new(round_slug: params[:round_slug])
  end

  def create
    @gallery = Gallery.new gallery_params
    authorize @gallery

    @gallery.user = current_user
    if @gallery.save
      flash[:success] = '게시되었습니다'
      redirect_to galleries_path(round_slug: @gallery.round_slug)
    else
      errors_to_flash(@gallery)
      render :new
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    authorize @gallery
  end

  def update
    @gallery = Gallery.find(params[:id])
    authorize @gallery

    @gallery.assign_attributes(gallery_params)
    if @gallery.save
      flash[:success] = '저장되었습니다'
      redirect_to galleries_path(round_slug: @gallery.round_slug, gallery_id: @gallery.id, page: params[:page])
    else
      errors_to_flash(@gallery)
      render :new
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    authorize @gallery

    if @gallery.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to galleries_path(round_slug: @gallery.round_slug)
    else
      errors_to_flash(@gallery)
      redirect_to @gallery
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(:round_slug, :title, :body, :image, :image_cache)
  end
end