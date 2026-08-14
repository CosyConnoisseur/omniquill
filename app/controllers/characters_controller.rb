class CharactersController < ApplicationController
  include ActionController::Live
  before_action :set_campaign, only: [:new, :create]

  def show
    @character = Character.find(params[:id])
    authorize @character
  end

  def new
    @character = Character.new
    authorize @character
    @stream_id = SecureRandom.hex(10)
  end

  def create
    # temp_participation = Participation.first || Participation.create!
    participation = Participation.find_or_create_by!(campaign_id: params[:campaign_id], user_id: current_user.id)
    @character = Character.new(character_params.merge(participation_id: participation.id))
    authorize @character

    if @character.save
      flash[:white_fade_in] = true
      redirect_to @character, notice: "Character created successfully!"
    else
      render :new, status: :unprocessable_entity
      # redirect_back fallback_location: root_path, alert:  "Character must have a name and description!"
    end
  end

  def parse_sheet
    @character = Character.new
    authorize @character
    @stream_id = params[:stream_id] || SecureRandom.hex(10)

    uploaded_file = params[:character][:document_upload]
    response.headers['Content-Type'] = 'text/html'
    # ai magic uploaded_file
    model = RubyLLM.chat(
      provider: :gemini,
      assume_model_exists: true,
    )

    begin

      prompt = <<~TEXT
      You are an expert character sheet analyzer. Read the attached file and extract a name and a detailed statistical description for the character.

      You MUST format your output exactly like this:
      NAME: [Your Name Here]
      DESCRIPTION: [Your Description Here]

      Do not include any conversational filler outside of this structural layout.
    TEXT

    # model.ask(
    #   "You generate character names and descriptions based off of character sheets. You MUST format your response exactly like this:
    #           NAME: [Your Name Here]
    #           DESCRIPTION: [Your Description Here]",
    #   role: :system
    #   )

    full_response = model.ask(
      prompt,
      with: uploaded_file
      ) do |chunk|

      text_fragment = chunk.content

      if text_fragment.present?
        Turbo::StreamsChannel.broadcast_append_to(
          "character_generation_#{@stream_id}",
          target: "live_typewriter_output",
          html: text_fragment
        )
      end

      # Turbo::StreamsChannel.broadcast_append_to(
      #   "character_generation_#{@stream_id}",
      #   target: "live_typewriter_output",
      #   html: chunk
      # )
    end

    response_text = full_response.content
    puts "----- AI RESPONSE -----"
    puts response_text
    puts "-----------------------"
    extracted_name = response_text.match(/NAME:\s*(.*)/)&.captures&.first
    extracted_description = response_text.match(/DESCRIPTION:\s*([\s\S]*)/)&.captures&.first

    @generated_name = extracted_name&.strip
    @generated_description = extracted_description&.strip

    # @character.name = @generated_name
    # @character.stats_summary = @generated_description

    # @character = Character.new(
    #   name: @generated_name, #ai magic
    #   stats_summary: @generated_description #ai magic
    # )


    ensure
      response.stream.close
    end

    head :ok
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

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def character_params
    params.require(:character).permit(:name, :stats_summary, :portrait, :document_upload)
  end

end
