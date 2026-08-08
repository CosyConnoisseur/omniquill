class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all

    #just for testing
    @characters = Character.all
  end
end
