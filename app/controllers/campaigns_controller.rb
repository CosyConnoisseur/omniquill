class CampaignsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  def index
    @campaigns = policy_scope(Campaign)
    @characters = Character.all
  end

  def show
    @campaign = Campaign.find(params[:id])
    @characters = @campaign.characters
    @chapters = @campaign.chapters
    @notes = @campaign.notes
    authorize @campaign
  end

  def new
    @campaign = Campaign.new
    authorize @campaign
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user # assigning the current logged in user to the campaign
    authorize @campaign

    if @campaign.save
      redirect_to campaigns_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    @campaign = Campaign.find(params[:id])
    authorize @campaign, :join?
    @already_joined = @campaign.participations.exists?(user: current_user)
  end

  def add_player
    @campaign = Campaign.find(params[:id])
    authorize @campaign, :join?

    unless @campaign.participations.exists?(user: current_user)
      @campaign.participations.create!(
        user: current_user
      )
    end

    redirect_to campaigns_path
  end

    private
  def campaign_params
    params.expect(campaign: [:title])
  end
end
