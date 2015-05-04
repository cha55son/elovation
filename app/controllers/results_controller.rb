require 'uri'
require 'net/https'

class ResultsController < ApplicationController
  before_action :set_game

  def create
    collect_user_scores
    response = ResultService.create(@game, params[:result])

    if response.success?
      fire_webhooks(@game, response.result)
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

  def collect_user_scores
    # Store the users scores for the webhooks
    @scores = { }
    params[:result][:teams].each do |team|
      player_ids = team[1][:players].is_a?(String) ? [team[1][:players]] : team[1][:players]
      player_ids.each do |pid|
        next if pid.empty?
        player = @game.players.find(pid) 
        ratings = Player.find(pid).ratings.where(game: @game)
        if ratings.length == 0
          @scores[pid.to_i] = 0
        else
          @scores[pid.to_i] = ratings[0].value
        end
      end
    end
  end

  def fire_webhooks(game, result)
    Thread.new do
      output = "Result ##{result.id} for Game ##{game.id} (#{game.name}) submitted. Firing webhooks:\n"
      game.webhooks.each_with_index do |webhook, index|
        uri = URI.parse(webhook.url) 
        timeout = 10
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = timeout
        http.open_timeout = timeout
        if uri.scheme == 'https'
          http.use_ssl = true 
          http.ssl_timeout = timeout
        end
        start = Time.now
        code = ''
        begin
          request = Net::HTTP::Post.new(uri.path)
          request.add_field('Content-Type', 'application/json')
          request.body = { 
            payload: { 
              resource: 'result',
              action: 'create',
              game: game.as_json(except: [:player_id, :motion_active_at, :motion_absent_title, :motion_detected_title, :stream_url]),
              outcome: result.tie? ? 'tie' : 'defeat',
              winners: result.winners.map { |w| 
                hash = w.as_json
                hash['score'] = w.ratings.where(game: game)[0].value
                hash['delta_score'] = (hash['score'] - @scores[w.id]).to_s
                hash['delta_score'] = '+' + hash['delta_score'] if hash['delta_score'].to_i >= 0
                hash
              },
              losers: result.losers.map { |l|
                hash = l.as_json
                hash['score'] = l.ratings.where(game: game)[0].value
                hash['delta_score'] = (hash['score'] - @scores[l.id]).to_s
                hash['delta_score'] = '+' + hash['delta_score'] if hash['delta_score'].to_i >= 0
                hash
              }
            }
          }.to_json
          response = http.request(request)
          code = response.code
        rescue StandardError => e
          code = e.message
        end
        duration_ms = Time.now - start
        output += "* #{webhook.url} => [" + code + "] in #{duration_ms}s\n"
      end
      Rails.logger.info output
    end
  end
end
