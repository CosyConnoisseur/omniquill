class StickiesController < ApplicationController
  def new
    @sticky = Sticky.new
    @chapter = Chapter.find(params[:chapter_id])
    @campaign = Campaign.find(params[:campaign_id])
  end

  def create
    @sticky = Sticky.new(sticky_params)
    @chapter = Chapter.find(params[:chapter_id])
    @campaign = Campaign.find(params[:campaign_id])
    @sticky.user_id = current_user.id
    @sticky.chapter_id = @chapter.id
    if @sticky.save
      redirect_to campaign_chapter_path(@campaign, @chapter)
    else
      render :new, :unprocessable_entity
    end
  end

  private

  def sticky_params
    params.require(:sticky).permit(:text)
  end
end
