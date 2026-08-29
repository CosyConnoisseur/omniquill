class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update processing]
  before_action :set_campaign, only: %i[index show edit update processing]
  def index
    @chapters = policy_scope(@campaign.chapters)
  end

  def show
    authorize @chapter
    @sticky = Sticky.new
  end

  def edit
    authorize @chapter
  end

  def update
    authorize @chapter
    @chapter.update(chapter_params)
    redirect_to campaign_chapter_path(@campaign, @chapter)
  end

  def processing
    authorize @chapter, :show?

    render json: {
      completed: @chapter.title.present? && @chapter.summary.present? && @chapter.highlights.present?,
      chapter_id: @chapter.id
    }
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
