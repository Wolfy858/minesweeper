class Tile
  POS_NEIGHBORS = [
    [1, 1],
    [0 , 1],
    [-1, 1],
    [-1, 0],
    [-1, -1],
    [0, -1],
    [1, -1],
    [1, 0]
  ]
  attr_reader :board, :value :position

  def initialize(board, position)
    @board = board
    @value = :empty
    @revealed = false
    @flagged = false
    @position = position
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

  def bombed?
    self.value == :bomb
  end

  def neighbors
    x, y = position
    pos_neighbors = POS_NEIGHBORS.map { |pos| [x + pos[0], y + pos[1]] }
    pos_neigbors.reject { |pos| board[pos].nil? }
  end

  def neighbor_bomb_count
    bomb_count = 0
    neighbors.each {|neighbor| bomb_count += 1 if neighbor.bombed?}
    bomb_count
  end

  def set_bomb_count
    @value = neighbor_bomb_count
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
