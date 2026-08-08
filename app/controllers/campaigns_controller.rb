class CampaignsController < ApplicationController
  def index
    # @campaigns = Campaign.all
    @campaigns = policy_scope(Campaign)
    authorize @campaigns

    #just for testing
    @characters = Character.all
    authorize @characters
  end
end
