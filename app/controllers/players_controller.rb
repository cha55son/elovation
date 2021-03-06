class PlayersController < ApplicationController
  before_action :set_player, only: [:edit, :show, :update]

  def edit
  end

  def show
      @markdown_html = parse_markdown(@player.bio)
  end

  def update
    if @player.update_attributes(player_params)
      redirect_to player_path(@player)
    else
      render :edit
    end
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:bio)
  end
end
