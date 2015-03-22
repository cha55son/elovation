class DashboardController < ApplicationController
  def show
    @players = Player.all
    @games = Game.all.sort_by(&:name)
  end
end
