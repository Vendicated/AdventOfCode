require "../lib/day"

EMPTY = -1i64
ADD   =   0i8
MUL   =   1i8

alias Input = Tuple(Array(Array(Array(Int64))), Array(Int8))

class Day6 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    ops_line = lines.pop
    ops = [] of Int8
    line_ranges = [] of Tuple(Int32, Int32)

    last_idx = -1
    ops_line.each_char_with_index do |ch, idx|
      case ch
      when '+'
        ops << ADD
      when '*'
        ops << MUL
      else
        next
      end
      line_ranges << {last_idx, idx - 2} unless last_idx == -1
      last_idx = idx
    end
    line_ranges << {last_idx, ops_line.size - 1}

    col_count = line_ranges.size

    rows = lines.map do |line|
      Array.new col_count do |i|
        left, right = line_ranges[i]
        (left..right).to_a do |i|
          line[i] == ' ' ? EMPTY : line[i].to_i64
        end
      end
    end

    {rows, ops}
  end

  def part1(input) : Printable
    rows, ops = input

    sum = 0i64

    ops.each_with_index do |op, idx|
      col_sum = op == MUL ? 1i64 : 0i64

      rows.each do |row|
        x = row[idx].reduce 0i64 do |acc, curr|
          break acc if curr == EMPTY && acc > 0i64

          acc *= 10i64
          acc += curr unless curr == EMPTY
          acc
        end

        if op == MUL
          col_sum *= x
        else
          col_sum += x
        end
      end

      sum += col_sum
    end

    sum
  end

  def part2(input) : Printable
    rows, ops = input

    sum = 0i64

    ops.each_with_index do |op, idx|
      row_sum = op == MUL ? 1i64 : 0i64

      col_count = rows[0][idx].size
      col_count.times do |i|
        x = rows.reduce 0i64 do |acc, curr_row|
          curr = curr_row[idx][i]
          break acc if curr == EMPTY && acc > 0i64

          acc *= 10i64
          acc += curr unless curr == EMPTY
          acc
        end

        if op == MUL
          row_sum *= x
        else
          row_sum += x
        end
      end

      sum += row_sum
    end

    sum
  end
end

Day6.new
