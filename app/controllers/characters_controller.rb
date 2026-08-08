class CharactersController < ApplicationController
  def show
    @character = Character.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    @character = Character.find(params[:id])
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
