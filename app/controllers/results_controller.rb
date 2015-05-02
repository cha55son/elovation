require 'uri'
require 'net/https'

class ResultsController < ApplicationController
  before_action :set_game

  def create
    response = ResultService.create(@game, params[:result])

    if response.success?
      fire_webhooks(@game)
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

  def fire_webhooks(game)
      Thread.new do
        game.webhooks.each_with_index do |webhook, index|
          uri = URI.parse(webhook.url) 
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = 5
          http.open_timeout = 5
          http.use_ssl = true if uri.scheme == 'https'
          http.ssl_timeout = 5 if uri.scheme == 'https'
          start = Time.now
          output = ''
          begin
            request = Net::HTTP::Post.new(uri.path)
            request.add_field('Content-Type', 'application/json')
            request.body = { payload: "this is a test" }.to_s
            response = http.request(request)
            output = response.code
          rescue StandardError => e
            output = e.message
          end
          duration_ms = Time.now - start
          Rails.logger.info "Result for Game ##{game.id} (#{game.name}) submitted. Firing webhooks:" if index == 0
          Rails.logger.info "* #{webhook.url} => [" + output + "] in #{duration_ms}s"
        end
      end
  end
end
