class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all

    #just for testing
    @characters = Character.all
  end

  def show
    @campaign = Campaign.find(params[:id])
    @characters = @campaign.characters
    @chapters = @campaign.chapters
    @notes = @campaign.notes
  end
end
