require "../lib/day"

alias Input = Array(String)

def digit_count(x : Int64)
  1 + Math.log10(x).floor.to_i64
end

class Day2 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines.flat_map &.strip(',').strip.split(',')
  end

  def part1(input) : Printable
    invalid_sum = 0i64
    input.each do |range|
      range_start, range_end = range.split '-'

      (range_start.to_i64..range_end.to_i64).each do |n|
        digits = digit_count n
        next if digits % 2 != 0

        left, right = n.divmod(10 ** (digits // 2))

        invalid_sum += n if left == right
      end
    end

    invalid_sum
  end

  def part2(input) : Printable
    invalid_sum = 0i64

    input.each do |range|
      range_start, range_end = range.split '-'

      (range_start.to_i64..range_end.to_i64).each do |n|
        digits = digit_count n

        (1..digits // 2).each do |i|
          times_included = digits / i
          next if times_included % 1 != 0

          rest, left = n.divmod(10 ** i)

          is_symmetric = true
          (times_included.to_i - 1).times do
            rest, x = rest.divmod(10 ** i)
            if x != left
              is_symmetric = false
              break
            end
          end

          if is_symmetric
            invalid_sum += n
            break
          end
        end
      end
    end

    invalid_sum
  end
end

Day2.new
