require 'sinatra/base'
require_relative 'lib/game'

class Tig < Sinatra::Base
  enable :sessions
  include OXs_Game

  get '/' do
    session.clear
    erb :index
  end

  post '/game' do
    opts = {
        size: params[:size],
        mode: params[:mode]
    }
    @game = Game.new(opts)
    session['game'] = @game.session_hash
    erb :game
  end

  post '/game/move' do
    @game = Game.new(session['game'])
    @player_move = params[:grid_position]
    @game.round(@player_move)

    if @game.result
      session['result'] = @game.result
      redirect '/game/result'
    else
      session['game'] = @game.session_hash
      erb :game
    end
  end

  # TODO: Add 'New Game' button to this page
  get '/game/result' do
    @result = session['result']
    @game = Game.new(session['game'])
    erb :result
  end

end
