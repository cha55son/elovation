class GamesController < ApplicationController
  before_action :set_game, only: [:motion, :destroy, :edit, :show, :update]
  skip_before_action :authenticate_player!, only: [:motion, :motion_clear]

  def motion
    @game.motion_active_at = Time.now
    @game.save!
    render text: 'success'
  end

  def motion_clear
    seconds = 30
    Rails.logger.info "Clearing games with motion greater than #{seconds} seconds..."
    Game.all.find_each do |game|
      next if game.motion_active_at.nil?
      game.motion_active_at = nil if (Time.new - game.motion_active_at) >= seconds
      game.save
    end
    Rails.logger.info "Finished clearing games."
    render text: 'success'
  end

  def create
    @game = Game.new(games_params)

    if @game.save
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def destroy
    @game.destroy if @game.results.empty?
    redirect_to dashboard_path
  end

  def edit
  end

  def new
    @game = Game.new min_number_of_players_per_team: 1,
                     rating_type: "trueskill",
                     min_number_of_teams: 2,
                     allow_ties: true
  end

  def show
    @ratings = @game.all_ratings.select(&:active?)
  end

  def update
    if @game.update_attributes(games_params)
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def games_params
    params.require(:game).permit(:name,
                                :rating_type,
                                :min_number_of_teams,
                                :max_number_of_teams,
                                :min_number_of_players_per_team,
                                :max_number_of_players_per_team,
                                :allow_ties,
                                :stream_url,
                                :motion_detected_title,
                                :motion_absent_title)
  end
end
