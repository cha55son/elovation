require 'uri'
require 'net/https'

class ResultsController < ApplicationController
  before_action :set_game

  def create
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
              winners: result.winners.as_json,
              losers: result.losers.as_json
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
