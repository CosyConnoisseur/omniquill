class ParticipationsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @campaign = Campaign.find(params[:campaign_id])

    @participation = @campaign.participations.find_by!(user: current_user)

    authorize @participation

    @participation.destroy

    redirect_to campaigns_path, notice: "You have successfully left #{@campaign.title}."
  end
end
