alias Pipe = {Int32, Int32}
alias PipeDouble = {Pipe, Pipe}

DefaultPipe = {-1, -1}

TileBlank   =  0
TileOutside = -1

def resolve_pipe_destinations(pipe : Char, x : Int32, y : Int32) : PipeDouble | Nil
  case pipe
  when '|'
    { {x, y - 1}, {x, y + 1} }
  when '-'
    { {x - 1, y}, {x + 1, y} }
  when 'L'
    { {x, y - 1}, {x + 1, y} }
  when 'J'
    { {x, y - 1}, {x - 1, y} }
  when '7'
    { {x, y + 1}, {x - 1, y} }
  when 'F'
    { {x, y + 1}, {x + 1, y} }
  when '.'
    nil
  end
end

def get_surrounding_tiles(x : Int32, y : Int32)
  [
    {x - 1, y - 1},
    {x - 1, y},
    {x - 1, y + 1},
    {x, y - 1},
    {x, y + 1},
    {x + 1, y - 1},
    {x + 1, y},
    {x + 1, y + 1},
  ]
end

def visit_surrounding_zeroes(mapping : Array(Array(Int32)), x : Int32, y : Int32)
  get_surrounding_tiles(x, y).each do |x, y|
    v = mapping.dig?(y, x)
    if v == TileBlank
      mapping[y][x] = TileOutside
      visit_surrounding_zeroes mapping, x, y
    end
  end
end

def solve(file : String)
  map = File.read_lines(file).map { |l| l.chars }
  mapping = Array(Array(Int32)).new
  (0...map.size).each do |i|
    arr = [] of Int32
    mapping << arr
    (0...map[0].size).each do |j|
      arr << TileBlank
    end
  end

  start = DefaultPipe

  map.each_with_index do |line, y|
    x = line.index 'S'

    if !x.nil?
      start = {x, y}
      break
    end
  end

  start_x, start_y = start
  mapping[start_y][start_x] = 1

  connected_pipes_arr = get_surrounding_tiles(start_x, start_y).select! do |(x, y)|
    v = map.dig?(y, x)
    if !v.nil?
      dest = resolve_pipe_destinations v, x, y
      dest && (dest[0] == start || dest[1] == start)
    else
      false
    end
  end

  previous_pipes = {start, start}
  connected_pipes = PipeDouble.from(connected_pipes_arr)

  steps = 0
  loop do
    steps += 1

    done = false

    pipes = connected_pipes

    (0..1).each do |i|
      x, y = connected_pipes[i]
      if mapping[y][x] != TileBlank
        done = true
        break
      end

      mapping[y][x] = steps
      next_pipe_candidates = resolve_pipe_destinations(map[y][x], x, y).not_nil!

      next_pipe = next_pipe_candidates[0] == previous_pipes[i] ? next_pipe_candidates[1] : next_pipe_candidates[0]

      connected_pipes = i == 0 ? {next_pipe, connected_pipes[1]} : {connected_pipes[0], next_pipe}
    end

    previous_pipes = pipes

    break if done
  end

  # this isn't fully correct. it will only mark fields as outside that are surrounded by at least one 0
  # it doesn't correctly mark this 0. it is not surrounded by other 0 but also not surrounded by the pipe
  # F--
  # |OF
  # FJL

  outer_coords = [
    (0...mapping[0].size).map { |n| {n, 0} },
    (0...mapping[0].size).map { |n| {n, mapping.size - 1} },
    (0...mapping.size).map { |n| {0, n} },
    (0...mapping.size).map { |n| {mapping[0].size - 1, n} },
  ]

  outer_coords.each do |coords|
    coords.each do |x, y|
      next if mapping[y][x] != 0

      mapping[y][x] = TileOutside
      visit_surrounding_zeroes mapping, x, y
    end
  end

  puts file,
    mapping.map { |r| r.max }.max,
    mapping.map { |line| line.count(0) }.sum
end

solve "example.txt"
puts
solve "input.txt"
