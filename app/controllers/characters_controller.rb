class CharactersController < ApplicationController
  include ActionController::Live

  def show
    @character = Character.find(params[:id])
    authorize @character
  end

  def new
    @character = Character.new
    authorize @character
  end

  def create
    @character = Character.new(character_params)
    authorize @character
  end

  def parse_sheet
    uploaded_file = params[:character][:document_upload]
    # ai magic uploaded_file
    model = RubyLLM.chat(
      provider: :gemini,
      assume_model_exists: true,
      system: "You generate character names and descriptions based off of character sheets. You MUST format your response exactly like this:
              NAME: [Your Name Here]
              DESCRIPTION: [Your Description Here]",
      with: uploaded_file
    )

    model.ask(
      "Create a title and description for this character") do |chunk|
      Turbo::StreamsChannel.broadcast_append_to(
        "character_generation_#{@character.id}",
        target: "live_typewriter_output",
        html: chunk
      )
    end

    full_response = model.last_message.content

    extracted_name = full_response.match(/NAME:\s*(.*)/)&.captures&.first
    extracted_description = full_response.match(/DESCRIPTION:\s*([\s\S]*)/)&.captures&.first

    @generated_name = extracted_name&.strip
    @generated_description = extracted_description&.strip

  ensure
    response.stream.close


    @character = Character.new(
      name: @generated_name, #ai magic
      stats_summary: @generated_description #ai magic
    )
    render :new
  end

  def edit
  end

  def update
    @character = Character.find(params[:id])
    authorize @character
    @character.update!(character_params)
    redirect_to character_path(@character)
  end

  def destroy
  end


  private

  def character_params
    params.require(:character).permit(:name, :stats_summary, :portrait)
  end

end
