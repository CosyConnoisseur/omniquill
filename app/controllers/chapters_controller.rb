class ChaptersController < ApplicationController
  def index
    @campaign = Campaign.find(params[:id])
    @chapters = @campaign.chapters
  end

  def show
    @chapter = Chapter.find(params[:id])
  end
end
