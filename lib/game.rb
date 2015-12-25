module OXs_Game
  class Game

    attr_accessor :grid, :player_1, :player_2, :mode, :size, :turn, :message, :result

    def initialize(opts)
      @size     = opts[:size]
      @mode     = opts[:mode] ||"human"
      @turn     = opts[:turn]
      @grid     = opts[:grid] || get_grid(@size)
      @player_1 = 'X'
      @player_2 = '0'
      @result   = nil
      @message  = opts[:message] || 'Welcome to the Fields of Strife'
    end

    def round(position)
      game     = game_class.new(session_hash)
      game.round(position)
      @grid    = game.grid
      @mode    = game.mode
      @size    = game.size
      @turn    = game.turn
      @message = game.message
      @result  = game.result
    end

    def session_hash
      {
          size: @size,
          mode: @mode,
          turn: @turn,
          message: @message,
          result: @result,
          grid: @grid
      }
    end

    private

    def game_class
      Game3x3
    end

    def get_grid(size)
      Game3x3::GRID
    end

  end


  class Game3x3
    GRID = {'a1' => ' ', 'b1' => ' ', 'c1' => ' ',
            'a2' => ' ', 'b2' => ' ', 'c2' => ' ',
            'a3' => ' ', 'b3' => ' ', 'c3' => ' '}

    WIN_CONDITIONS = [
        ['a1', 'a2', 'a3'], # 0 vertical win
        ['b1', 'b2', 'b3'], # 1 vertical win
        ['c1', 'c2', 'c3'], # 2 vertical win
        ['a1', 'b1', 'c1'], # 3 horizontal win
        ['a2', 'b2', 'c2'], # 4 horizontal win
        ['a3', 'b3', 'c3'], # 5 horizontal win
        ['a1', 'b2', 'c3'], # 6 diagonal win
        ['a3', 'b2', 'c1']  # 7 diagonal win
    ]

    POSITION_REGEX         = /[abc][1-3]/i
    POSITION_REGEX_REVERSE = /[1-3][abc]/i

    attr_accessor :grid, :player_1, :player_2, :mode, :size, :turn, :message, :result

    def initialize(opts)
      @player_1    = 'X'
      @player_2    = '0'
      @grid        = opts[:grid]
      @mode        = opts[:mode]
      @size        = opts[:size]
      @turn        = opts[:turn] || @player_1
      @message     = opts[:message]
      @result      = nil
    end

    def round(position)
      if @mode == 'human'
        get_player_input(position)
        switch_turns
        human_results
      end
    end

    private

    def human_results
      if win?(@player_1)
        @result = "#{@player_1} wins! Congrats!"
      elsif win?(@player_2)
        @result = "#{@player_2} wins! Congrats!"
      elsif grid_full?
        @result = 'Stalemate'
      end
    end

    def switch_turns

      if @turn == @player_1
        @turn = @player_2
      elsif @turn == @player_2
        @turn = @player_1
      end
    end

    def get_player_input(position)
      if valid_move?(position)
        @grid[position.downcase] = @turn
        @message = 'Movement accepted.'
      elsif valid_position_format?(position)
        @message = 'Invalid input. That position is taken.'
      else
        @message = 'Invalid input. That is not a valid position.'
      end
    end

    def valid_move?(position)
      (valid_position_format?(position)) && (@grid[position.downcase] == ' ')
    end

    def valid_position_format?(position)
      (position =~ POSITION_REGEX) || (position =~ POSITION_REGEX_REVERSE)
    end

    def grid_full?
      !@grid.has_value?(' ')
    end

    def win?(mark)
      vertical_win?(mark) || horizontal_win?(mark) || diagonal_win?(mark)
    end

    def horizontal_win?(mark)
      three_in_a_row?(mark, WIN_CONDITIONS[3]) || three_in_a_row?(mark, WIN_CONDITIONS[4]) || three_in_a_row?(mark, WIN_CONDITIONS[5])
    end

    def vertical_win?(mark)
      three_in_a_row?(mark, WIN_CONDITIONS[0]) || three_in_a_row?(mark, WIN_CONDITIONS[1]) || three_in_a_row?(mark, WIN_CONDITIONS[2])
    end

    def diagonal_win?(mark)
      three_in_a_row?(mark, WIN_CONDITIONS[6]) || three_in_a_row?(mark, WIN_CONDITIONS[7])
    end

    def three_in_a_row?(mark, win_condition)
      (@grid[win_condition[0]] == mark) && (@grid[win_condition[1]] == mark) && (@grid[win_condition[2]] == mark)
    end

    def start_of_game?
      @grid.values.uniq.length == 2
    end

    def position_empty?(position)
      @grid[position] == ' '
    end

    def corner_defense?
      side_positions = [@grid['a2'], @grid['b1'], @grid['b3'], @grid['c2']]
      side_positions.count(' ') == 1
    end

    def side_defense?
      corner_positions = [@grid['a1'], @grid['a3'], @grid['c1'], @grid['c3']]
      side_positions   = [@grid['a2'], @grid['b1'], @grid['b3'], @grid['c2']]
    end

    def opposite_corners?
      (@grid['a1'] == @player_1 && @grid['c3'] == @player_1) || (@grid['a3'] == @player_1 && @grid['c1'] == @player_1)
    end
  end
end