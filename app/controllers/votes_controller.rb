class VotesController < ApplicationController
  def create
    render_403 and return unless user_signed_in?

    @poll = Poll.find(params[:poll_id])
    render_404 and return if @poll.blank?

    @poll.votes.create(user: current_user)

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js
    end
  end

  def destroy
    render_403 and return unless user_signed_in?

    @poll = params[:likable_type].try(:safe_constantize).try(:find, params[:likable_id])
    render_404 and return if @poll.blank?

    @poll.votes.find_by(user: current_user).try(:destroy)

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js
    end
  end
end
