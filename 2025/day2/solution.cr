require "../lib/day"

alias Input = Array(String)

def digit_count(x : Int64) : Int64
  1i64 + Math.log10(x).floor.to_i64
end

class Day2 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines.flat_map &.strip(',').strip.split(',')
  end

  def part1(input) : Printable
    invalid_sum = 0i64
    input.each do |range|
      start, finish = range.split('-', 2).map &.to_i64

      (start..finish).each do |n|
        digits = digit_count n
        next if digits % 2i64 != 0i64

        divisor = 10i64 ** (digits // 2i64)
        left, right = n.divmod(divisor)

        if left == right
          invalid_sum += n
        end
      end
    end

    invalid_sum
  end

  def part2(input) : Printable
    invalid_sum = 0i64

    input.each do |range|
      range_start, range_end = range.split('-', 2)
      start = range_start.to_i64
      finish = range_end.to_i64

      (start..finish).each do |n|
        digits = digit_count n

        (1i64..digits // 2i64).each do |i|
          next if digits % i != 0i64
          times_included = digits // i

          divisor = 10i64 ** i
          rest, left = n.divmod(divisor)

          is_symmetric = true
          (times_included - 1i64).times do
            rest, x = rest.divmod(divisor)
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
