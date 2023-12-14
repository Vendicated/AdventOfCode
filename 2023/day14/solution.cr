def tilt_north(map)
  (0...map.first.size).each do |j|
    loop do
      did_change = false
      (1...map.size).each do |i|
        if map[i][j] == 'O' && map[i - 1][j] == '.'
          map[i][j] = '.'
          map[i - 1][j] = 'O'
          did_change = true
        end
      end

      break unless did_change
    end
  end
end

def tilt_west(map)
  map.each do |line|
    loop do
      did_change = false
      (1...line.size).each do |i|
        if line[i] == 'O' && line[i - 1] == '.'
          line[i] = '.'
          line[i - 1] = 'O'
          did_change = true
        end
      end

      break unless did_change
    end
  end
end

def tilt_south(map)
  (0...map.first.size).each do |j|
    loop do
      did_change = false
      (map.size - 2..0).step(-1).each do |i|
        if map[i][j] == 'O' && map[i + 1][j] == '.'
          map[i][j] = '.'
          map[i + 1][j] = 'O'
          did_change = true
        end
      end

      break unless did_change
    end
  end
end

def tilt_east(map)
  map.each do |line|
    loop do
      did_change = false
      (map.size - 2..0).step(-1).each do |i|
        if line[i] == 'O' && line[i + 1] == '.'
          line[i] = '.'
          line[i + 1] = 'O'
          did_change = true
        end
      end

      break unless did_change
    end
  end
end

def rotate(map)
  tilt_north map
  tilt_west map
  tilt_south map
  tilt_east map
end

def calculate_load(map)
  total_load = 0
  map.each_with_index do |line, i|
    line_load = map.size - i
    total_load += line_load * line.count('O')
  end

  total_load
end

def solve1(file)
  map = File.read_lines(file).map &.chars
  tilt_north map

  puts calculate_load map
end

def solve2(file)
  map = File.read_lines(file).map &.chars

  prev_maps = {} of Array(Array(Char)) => Int32
  rotations_done = 0
  cycle_happens_after = 0

  1000000000.times do |i|
    rotate map

    dump = map.map &.dup
    if prev_maps.has_key? dump
      rotations_done = i + 1
      cycle_happens_after = i - prev_maps[dump]
      break
    end

    prev_maps[dump] = i
  end

  rotations_left = 1000000000 - rotations_done
  rotations_left %= cycle_happens_after

  rotations_left.times do
    rotate map
  end

  puts calculate_load map
end

def solve(file)
  puts file
  solve1 file
  solve2 file
end

solve "example.txt"
puts
solve "input.txt"
