class CharactersController < ApplicationController
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
    @character = Character.new(
      name: "blah", #ai magic
      stats_summary: "blah" #ai magic
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
