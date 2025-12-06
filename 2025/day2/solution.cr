require "../lib/day"

alias Input = Array(String)

# PEAK optimisation (log10 is SLOOOOOW)
def digit_count(x)
  if x < 10i64
    1i64
  elsif x < 100i64
    2i64
  elsif x < 1_000i64
    3i64
  elsif x < 10_000i64
    4i64
  elsif x < 100_000i64
    5i64
  elsif x < 1_000_000i64
    6i64
  elsif x < 10_000_000i64
    7i64
  elsif x < 100_000_000i64
    8i64
  elsif x < 1_000_000_000i64
    9i64
  elsif x < 10_000_000_000i64
    10i64
  else
    11i64
  end
end

def each_chunk_size(digits : Int64, &)
  case digits
  when 2, 3, 5, 7, 11
    yield 1
  when 4
    yield 2
  when 6
    yield 2
    yield 3
  when 8
    yield 2
    yield 4
  when 9
    yield 3
  when 10
    yield 2
    yield 5
  end
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

        each_chunk_size digits do |chunk_size|
          divisor = 10i64 ** chunk_size
          rest, left = n.divmod(divisor)

          is_symmetric = true
          (digits // chunk_size - 1i64).times do
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
