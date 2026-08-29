class NotesController < ApplicationController
  def create
    @campaign = Campaign.find(params[:campaign_id])
    @note = @campaign.notes.build(note_params)
    @note.user = current_user

    authorize @note

    if @note.save
      redirect_to campaign_path(@campaign, anchor: "notes-tab"), notice: "Note added successfully!", status: :see_other
    else
      redirect_to @campaign, alert: "Failed to add note."
    end
  end

  def destroy
    @campaign = Campaign.find(params[:campaign_id])
    @note = Note.find(params[:id])
    authorize @note

    @note.destroy

    redirect_to campaign_path(@campaign, anchor: "notes-tab"),
                  notice: "Note deleted successfully!",
                  status: :see_other
  end

  private

  def note_params
    params.require(:note).permit(:entry)
  end
end
