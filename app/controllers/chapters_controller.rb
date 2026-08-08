class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update]
  before_action :set_campaign, only: %i[index show edit update]
  def index
    @chapters = @campaign.chapters
  end

  def show
  end

  def edit
  end

  def update
    @chapter.update(chapter_params)
    redirect_to campaign_chapter_path(@campaign, @chapter)
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def chapter_params
    params.require(:chapter).permit(:title, :summary, :highlights)
  end
end
