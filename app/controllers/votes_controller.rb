class VotesController < ApplicationController
  def create
    # render_403 and return
    render_403 and return unless user_signed_in?

    @poll = Poll.find(params[:poll_id])
    render_404 and return if @poll.blank? or @poll.round_slug != 'final'

    @poll.votes.create(user: current_user)

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js
    end
  end

  def destroy
    render_403 and return unless user_signed_in?

    @poll = Poll.find(params[:poll_id])
    render_404 and return if @poll.blank? or @poll.round_slug != 'final'

    @poll.votes.find_by(user: current_user).try(:destroy)

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js
    end
  end
end
