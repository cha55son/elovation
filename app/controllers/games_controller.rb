class GamesController < ApplicationController
  skip_before_action :authenticate_player!, only: [:motion, :motion_clear]
  before_action :set_game, only: [:motion, :destroy, :edit, :show, :update]
  before_action :can_edit?, only: [:edit, :update, :destroy]

  def motion
    @game.motion_active_at = Time.now
    @game.save!
    render text: 'success'
  end

  def motion_clear
    seconds = 30
    Rails.logger.info "Clearing games with motion older than #{seconds} seconds..."
    Game.all.find_each do |game|
      next if game.motion_active_at.nil?
      game.motion_active_at = nil if (Time.new - game.motion_active_at) >= seconds
      game.save
    end
    Rails.logger.info "Finished clearing games."
    render text: 'success'
  end

  def new
    @game = Game.new rating_type: "trueskill",
                     allow_ties: true
  end

  def create
    @game = Game.new(games_params)
    # Force the minimums for the time being.
    @game.min_number_of_teams = 2
    @game.min_number_of_players_per_team = 1
    @game.player_id = current_player.id

    if @game.save
      redirect_to game_path(@game)
    else
      @game.player_id = nil
      render :new
    end
  end

  def destroy
    @game.destroy if @game.results.empty?
    redirect_to dashboard_path
  end

  def edit
  end

  def show
    @ratings = @game.all_ratings.limit(20)
    @markdown_html = parse_markdown(@game.description)
  end

  def update
    if @game.update(games_params)
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def can_edit?
    redirect_to game_path(@game) unless @game.can_edit?(current_player)
  end

  def games_params
    params.require(:game).permit(
        :name,
        :rating_type,
        :max_number_of_teams,
        :max_number_of_players_per_team,
        :allow_ties,
        :stream_url,
        :motion_detected_title,
        :motion_absent_title,
        :player_id,
        :description,
        webhooks_attributes: [:id, :url, :_destroy]
    )
  end
end
