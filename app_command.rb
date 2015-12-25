require 'sinatra/base'
require_relative 'lib/game'

class AppCommand

  include OXs_Game

  puts "Enter grid size"
  size = gets.chomp
  size ="3x3"
  puts "Enter game mode"
  mode = gets.chomp
  mode = "human"
  opts = {
      size: size,
      mode: mode
  }

  puts "Human vs Human. Fight!"
  puts "Player 1 Movement 'X' "
  puts "Player 2 Movement '0' "
  puts "Game Going to Start......."
  #start
  @game = Game.new(opts)
  #start2

  begin

    if @game.turn == @game.player_2
      puts "Player 2 Turn"
    else
      puts "Player 1 Turn"
    end
    puts "Enter your postion"
    grid_position = gets.chomp
    @player_move = grid_position
    @game.round(@player_move)
    if @game.result
      puts "Game Result"
      puts "----------"
      puts @game.result
      puts "----------"
      puts "     A   B   C"
      puts "1   #{@game.grid['a1']}    #{@game.grid['b1']}   #{@game.grid['c1']}"
      puts "2   #{@game.grid['a2']}    #{@game.grid['b2']}   #{@game.grid['c2']}"
      puts "3   #{@game.grid['a3']}    #{@game.grid['b3']}   #{@game.grid['c3']}"
      puts "Game End"
    else
      puts "Game Postions"
      puts "     A   B   C"
      puts "1   #{@game.grid['a1']}    #{@game.grid['b1']}   #{@game.grid['c1']}"
      puts "2   #{@game.grid['a2']}    #{@game.grid['b2']}   #{@game.grid['c2']}"
      puts "3   #{@game.grid['a3']}    #{@game.grid['b3']}   #{@game.grid['c3']}"
      puts @game.message
      if @player_move && !@player_move.empty?
        puts "Your input was #{@player_move.upcase}."
      end
    end

  end until @game.result != nil

end