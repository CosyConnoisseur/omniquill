class CampaignsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  def index
    @campaigns = policy_scope(Campaign)
    @characters = Character.all
  end
end
