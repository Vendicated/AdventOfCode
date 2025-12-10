require "../lib/day"

alias Input = Array(Tuple(Int64, Int64))

class Day9 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines.map do |line|
      x, y = line.split ','
      {x.to_i64, y.to_i64}
    end
  end

  def part1(input) : Printable
    max = 0i64
    input.each do |p1|
      input.each do |p2|
        max = {
          max,
          (1i64 + (p1[0] - p2[0]).abs) * (1i64 + (p1[1] - p2[1]).abs),
        }.max
      end
    end

    max
  end

  def part2(input) : Printable
    "TODO"
  end
end

Day9.new
