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
    authorize @campaign
    @campaign.user = current_user # assigning the current logged in user to the campaign

    if @campaign.save
      redirect_to campaigns_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
    authorize @campaign
  end

  def update
    @campaign = Campaign.find(params[:id])
    authorize @campaign

    if @campaign.update(campaign_params)
      redirect_back fallback_location: root_path, notice: "Campaign updated successfully!", status: :see_other
    else
      redirect_back fallback_location: root_path, alert: "Failed to update campaign.", status: :unprocessable_entity
    end
    # @campaign.update!(campaign_params)
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

  def record
    @campaign = Campaign.find(params[:id])
    @test_chapter = @campaign.chapters.last
    authorize @campaign
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    authorize @campaign

    @campaign.destroy

    redirect_to campaigns_path, notice: "Campaign was successfully deleted.", status: :see_other
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :card_image, :banner, :synopsis)
  end
end
