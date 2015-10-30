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
  attr_reader :board, :value, :position

  def initialize(board, position)
    @board = board
    @value = 0
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

  def to_s
    self.bombed? ? "B" : value.to_s
  end

end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    initialize_tiles
    display
    #populate_bombs(10)
    #populate_remaining_tiles
  end
  #
  def initialize_tiles
    grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        self[i,j] = Tile.new(self, [i, j])
      end
    end
  end

  def populate_bombs(n_bombs)
    pos_indices = (0..8).to_a
    populated_bombs = 0

    until populated_bombs == n_bombs
      pos_position = [pos_indices.sample, pos_indices.sample]
      p grid[*pos_position]
      unless grid[*pos_position].bombed?
        grid[*pos_position].set_bomb
        populated_bombs += 1
      end
    end
  end

  def populate_remaining_tiles
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        tile.set_bomb_count unless tile.bombed?
      end
    end
  end

  # def [](row, col)
  #   grid[row][col]
  # end
  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, value)
    @grid[row][col] = value
  end

  def display
    grid.each do |row|
      print_row = []
      row.each do |tile|
        print_row << tile.to_s
      end
      puts print_row.join(" ")
    end
  end
end

b = Board.new
#b.display
