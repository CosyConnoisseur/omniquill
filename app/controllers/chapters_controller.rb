class ChaptersController < ApplicationController
  def index
    @campaign = Campaign.find(params[:id])
    @chapters = @campaign.chapters
  end
end
