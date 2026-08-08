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
  end

  def destroy
  end


  private

  def character_params
    # Append :portrait to your permitted attributes
    params.require(:character).permit(:name, :class, :bio, :portrait)
  end

end
