require "../lib/day"

def is_level_safe(level : Int32, prev_level : Int32, next_level : Int32)
  prev_diff, next_diff = prev_level - level, level - next_level

  return false if prev_diff.abs > 3 || prev_diff.abs < 1
  return false if next_diff.abs > 3 || next_diff.abs < 1
  return false if (prev_diff > 0 && next_diff < 0) || (prev_diff < 0 && next_diff > 0)

  true
end

def is_report_safe(report : Array(Int32))
  (1..report.size - 2).all? do |i|
    is_level_safe report[i], report[i - 1], report[i + 1]
  end
end

alias Reports = Array(Array(Int32))

class Day2 < Day(Reports)
  def parse_input(lines : Array(String)) : Reports
    lines.map &.split.map &.to_i
  end

  def part1(input) : Printable
    input.count { |r| is_report_safe r }
  end

  def part2(input) : Printable
    input.count do |r|
      if is_report_safe r
        next true
      end

      # lazy brute force
      (0..r.size - 1).any? do |i|
        new_arr = r.clone
        new_arr.delete_at i

        is_report_safe new_arr
      end
    end
  end
end

Day2.new
