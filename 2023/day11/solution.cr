alias Point = Tuple(Int32, Int32)
alias Vector = Tuple(Point, Point)

Galaxy    = '#'
Blank     = '.'
BlankLine = '~'

def sort_low(x, y)
  return y, x if x > y
  return x, y
end

def solve(file : String)
  sum1 = 0
  sum2 = 0_i64

  map = File.read_lines(file).map { |l| l.chars }

  # mark horizontal blanks
  map.each do |line|
    line.fill(BlankLine) if line.all? Blank
  end

  # mark vertical blanks
  (0...map[0].size).each do |i|
    next if map.any? { |l| l[i] != Blank && l[i] != BlankLine }

    map.each do |line|
      line[i] = BlankLine
    end
  end

  galaxies = [] of Point
  pairs = Set(Vector).new

  map.each_with_index do |line, i|
    line.each_with_index do |c, j|
      galaxies << {i, j} if c == Galaxy
    end
  end

  galaxies.each_with_index do |p1, i|
    galaxies.each_with_index do |p2, j|
      next if p1 == p2

      tuple = i > j ? {p2, p1} : {p1, p2}
      pairs << tuple
    end
  end

  pairs.each do |p1, p2|
    i1, i2 = sort_low p1[0], p2[0]
    j1, j2 = sort_low p1[1], p2[1]

    (i1..i2).each do |i|
      is_blank = map[i][j1] == BlankLine
      sum1 += is_blank ? 2 : 1
      sum2 += is_blank ? 1000000 : 1
    end
    (j1..j2).each do |j|
      is_blank = map[i2][j] == BlankLine
      sum1 += is_blank ? 2 : 1
      sum2 += is_blank ? 1000000 : 1
    end

    sum1 -= 2
    sum2 -= 2
  end

  puts file, sum1, sum2
end

solve "example.txt"
puts
solve "input.txt"
