class Tile
  attr_reader :board, :value

  def initialize(board)
    @board = board
    @value = :empty
    @revealed = false
    @flagged = false
  end

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged = true
  end

  def set_bomb
    @value = :bomb
  end

  def bomb?
    self.value == :bomb
  end

end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    populate_bombs
  end

  def populate_bombs(n_bombs)
    pos_indices = (0..8).to_a
    populated_bombs = 0

    until populated_bombs == n_bombs
      pos_position = [pos_indices.sample, pos_indices.sample]
      unless grid[pos_position].bomb?
        grid[pos_position].set_bomb
        populated_bombs += 1
      end
    end
  end

  def [](row, col)
    grid[row][col]
  end

  def []=([row, col], value)
    grid[row][col] = value
  end
end
