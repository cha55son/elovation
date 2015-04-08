class ResultsController < ApplicationController
  before_action :set_game

  def create
    response = ResultService.create(@game, params[:result])

    if response.success?
      redirect_to game_path(@game)
    else
      @result = response.result
      render :new
    end
  end

  def destroy
    unless @game.can_edit?(current_player)
        Rails.logger.warn "User #{current_player.name} (#{current_player.id}) was not allowed to delete result id '#{params[:id]}' for game id '#{@game.id}'."
        return redirect_to :back
    end
    result = @game.results.find_by_id(params[:id])
    response = ResultService.destroy(result)
    redirect_to :back
  end

  def new
    @result = Result.new
    (@game.max_number_of_teams || 20).times{ |i| @result.teams.build rank: i }
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
