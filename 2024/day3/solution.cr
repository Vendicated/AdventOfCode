require "../lib/day"

alias Input = String

class Day3 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines.join
  end

  def part1(input) : Printable
    regex = /mul\((\d+),(\d+)\)/
    input.scan(regex).sum do |m|
      m[1].to_i * m[2].to_i
    end
  end

  def part2(input) : Printable
    on = true
    regex = /mul\((\d+),(\d+)\)|(do|don't)\(\)/

    input.scan(regex).sum do |m|
      if m[0] == "do()"
        on = true
      elsif m[0] == "don't()"
        on = false
      elsif on
        next m[1].to_i * m[2].to_i
      end

      0
    end
  end
end

Day3.new
