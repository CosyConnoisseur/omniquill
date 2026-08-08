class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update]
  def index
    @campaign = Campaign.find(params[:id])
    @chapters = @campaign.chapters
  end

  def show
  end

  def edit
  end

  def update
    @chapter.update(chapter_params)
    redirect_to chapter_path(@chapter)
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def chapter_params
    params.require(:chapter).permit(:title, :summary, :highlights)
  end
end
