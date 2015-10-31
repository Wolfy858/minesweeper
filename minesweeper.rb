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
    find_neighbors.each do |neighbor|
      neighbor.reveal if neighbor.value == 0
    end
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

  def find_neighbors
    x, y = position
    pos_neighbors = POS_NEIGHBORS.map { |pos| [x + pos[0], y + pos[1]] }
    # p pos_neighbors
    pos_neighbors = pos_neighbors.select { |pos| pos[0].between?(0,8) && pos[1].between?(0,8)}
    # p pos_neighbors
    pos_neighbors.map {|pos| board[*pos]}
  end

  def neighbor_bomb_count
    bomb_count = 0
    neighbors = find_neighbors
    # p neighbors
    neighbors.each {|neighbor| bomb_count += 1 if neighbor.bombed?}
    bomb_count
  end

  def set_bomb_count
    @value = neighbor_bomb_count
  end

  def to_s
    return "F" if flagged?
    return "_" unless revealed?
    self.bombed? ? "B" : value.to_s
  end

end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    initialize_tiles
    # display
    populate_bombs(10)
    populate_remaining_tiles
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
      row, column = [pos_indices.sample, pos_indices.sample]
      # p grid[*pos_position]
      unless self[row, column].bombed?
        self[row, column].set_bomb
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

  def flag(position)
    self[*position].flag
  end

  def reveal(position)
    game_over if self[*position].bombed?
    self[*position].reveal
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

  def won?
    grid.flatten.all? do |tile|
      tile.bombed? || tile.revealed?
    end
  end

  def valid_position?(position)
    !self[*position].revealed?
  end
end

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    until board.won?
      prompt
    end
    puts "You win!"
  end

  def prompt
    board.display
    puts "Flag (1) or reveal (2) a tile:"
    option = gets.chomp
    option = gets.chomp until valid_option?(option)
    puts "Input a position (x,y):"
    position = gets.chomp
    position = gets.chomp until valid_position?(position)

    case option
    when "1"
      board.flag(position)
    when "2"
      board.reveal(position)
    end
  end

  def valid_option?(usr_input)
    if ["1", "2"].include?(usr_input)
      true
    else
      puts "Please enter either 1 or 2"
      false
    end
  end

  def valid_position?(usr_input)
    x, y = parse_position(usr_input)
    if x.between?(0, 8) && y.between?(0, 8)
      if board.valid_position?([x, y]) # checks if tile is unexplored
        true
      else
        puts "Please enter position of unexplored tile (x,y)"
        false
      end
    else
      puts "Please enter valid position (x,y)"
      false
    end
  end

  def parse_position(usr_input)
    usr_input.split(",").map(&:to_i)
  end
end


#b = Board.new
#b.display

g = Game.new
g.prompt
