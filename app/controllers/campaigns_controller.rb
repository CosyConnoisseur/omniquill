class CampaignsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  def index
    authorize @campaigns = Campaign.all

    #just for testing
    @characters = Character.all
  end
end
