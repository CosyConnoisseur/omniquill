require "ruby_llm"

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
      You are an expert character sheet analyzer. Read the attached file and extract a name and statistical description for the character.

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

        cleaned_chunk = chunk.to_s.strip
        unless cleaned_chunk.empty? || cleaned_chunk.match?(/\A#+\z/)

      Turbo::StreamsChannel.broadcast_append_to(
        "character_generation_#{@stream_id}",
        target: "live_typewriter_output",
        html: chunk
      )
        end
    end

    response_text = full_response.content
    puts response_text
    extracted_name = response_text.match(/NAME:\s*(.*)/)&.captures&.first
    extracted_description = response_text.match(/DESCRIPTION:\s*([\s\S]*)/)&.captures&.first

    @generated_name = extracted_name&.strip
    @generated_description = extracted_description&.strip

    ensure
      response.stream.close
    end

    @character.name = @generated_name
    @character.stats_summary = @generated_description

    # @character = Character.new(
    #   name: @generated_name, #ai magic
    #   stats_summary: @generated_description #ai magic
    # )
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
