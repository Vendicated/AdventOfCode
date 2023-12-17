enum Direction
  Up
  Right
  Down
  Left
end

record State, i : Int32, j : Int32, direction : Direction

def next_state(state : State, direction = state.direction)
  i = state.i
  j = state.j

  case direction
  when Direction::Up
    i -= 1
  when Direction::Down
    i += 1
  when Direction::Right
    j += 1
  when Direction::Left
    j -= 1
  end

  State.new i, j, direction
end

def run_beam(visited : Set(State), grid : Array(Array(Char)), state : State)
  return if state.i < 0 || state.j < 0

  char = grid.dig? state.i, state.j
  return if char.nil?

  return if visited.includes? state
  visited << state

  dir = state.direction

  case char
  when '/'
    next_dir =
      case dir
      when Direction::Up
        Direction::Right
      when Direction::Down
        Direction::Left
      when Direction::Right
        Direction::Up
      when Direction::Left
        Direction::Down
      end
    run_beam visited, grid, next_state(state, next_dir.not_nil!)
  when '\\'
    next_dir =
      case dir
      when Direction::Up
        Direction::Left
      when Direction::Down
        Direction::Right
      when Direction::Right
        Direction::Down
      when Direction::Left
        Direction::Up
      end
    run_beam visited, grid, next_state(state, next_dir.not_nil!)
  when '-'
    if dir == Direction::Up || dir == Direction::Down
      run_beam visited, grid, next_state(state, Direction::Right)
      run_beam visited, grid, next_state(state, Direction::Left)
    else
      run_beam visited, grid, next_state(state)
    end
  when '|'
    if dir == Direction::Right || dir == Direction::Left
      run_beam visited, grid, next_state(state, Direction::Up)
      run_beam visited, grid, next_state(state, Direction::Down)
    else
      run_beam visited, grid, next_state(state)
    end
  else
    run_beam visited, grid, next_state(state)
  end
end

def run(grid : Array(Array(Char)), state : State)
  visited = Set(State).new
  run_beam visited, grid, state
  Set.new(visited.map { |s| {s.i, s.j} }).size
end

def solve(file : String)
  grid = File.read_lines(file).map &.chars

  part1_visited = run grid, State.new(0, 0, Direction::Right)
  part2_visited = 0

  (0...grid.size).each do |j|
    part2_visited = [
      run(grid, State.new(0, j, Direction::Down)),
      run(grid, State.new(grid.size - 1, j, Direction::Up)),
      part2_visited,
    ].max
  end

  (0...grid.first.size).each do |i|
    part2_visited = [
      run(grid, State.new(i, 0, Direction::Right)),
      run(grid, State.new(i, grid.first.size - 1, Direction::Left)),
      part2_visited,
    ].max
  end

  puts file, part1_visited, part2_visited
end

solve "example.txt"
puts
solve "input.txt"
