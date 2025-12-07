require "../lib/day"

alias Input = Array(Array(Char))

class Day7 < Day(Input)
  @@timeline_cache = {} of Tuple(Int32, Int32) => Int64

  def parse_input(lines : Array(String)) : Input
    lines.map &.chars
  end

  def run_beam(input, x, start_y)
    cache = @@timeline_cache

    split_count = 0
    timeline_count = 0i64

    (start_y...input.size).each do |y|
      coords = {x, y}
      if cache.has_key? coords
        timeline_count += cache[coords]
        break
      end

      if input[y][x] == '^'
        timeline_count += 1

        b1, b2 = run_beam(input, x - 1, y + 1), run_beam(input, x + 1, y + 1)
        split_count += 1 + b1[0] + b2[0]
        timeline = b1[1] + b2[1]
        timeline_count += timeline
        cache[coords] = timeline + 1
        break
      end
    end

    {split_count, timeline_count}
  end

  def part1(input) : Printable
    start = input[0].index! 'S'
    run_beam(input, start, 1)[0]
  end

  def part2(input) : Printable
    start = input[0].index! 'S'
    run_beam(input, start, 1)[1] + 1
  end
end

Day7.new
