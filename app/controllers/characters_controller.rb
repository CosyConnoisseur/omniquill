class CharactersController < ApplicationController
  def show
    @character = Character.find(params[:id])
    authorize @character
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
end
