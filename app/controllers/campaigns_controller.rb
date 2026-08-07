class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end
end
