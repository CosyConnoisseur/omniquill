class StickiesController < ApplicationController
  def new
    @sticky = Sticky.new
    @chapter = Chapter.find(params[:chapter_id])
    @campaign = Campaign.find(params[:campaign_id])
    authorize @sticky
  end

  def create
    @sticky = Sticky.new(sticky_params)
    @chapter = Chapter.find(params[:chapter_id])
    @campaign = Campaign.find(params[:campaign_id])
    authorize @sticky
    @sticky.user_id = current_user.id
    @sticky.chapter_id = @chapter.id
    if @sticky.save
      redirect_to campaign_chapter_path(@campaign, @chapter)
    else
      redirect_back fallback_location: root_path, alert: "A minimum of 3 and a maximum of 20 characters!"
    end
  end

  def destroy
    @sticky = Sticky.find(params[:id])
    authorize @sticky
    @sticky.destroy

    redirect_back fallback_location: root_path, notice: "Sticky was successfully deleted.", status: :see_other
  end

  private

  def sticky_params
    params.require(:sticky).permit(:text)
  end
end
