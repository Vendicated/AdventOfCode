def solve(file : String)
  suf_sum = 0
  pre_sum = 0

  File.each_line file do |line|
    numbers = line.split.map { |n| n.to_i }
    history_diffs = [numbers]

    loop do
      had_non_zero = false

      last_row = history_diffs.last
      len = last_row.size

      row = [] of Int32
      history_diffs << row

      last_row.each_with_index do |n, i|
        break if i == len - 1

        diff = last_row[i + 1] - n
        row << diff
        had_non_zero = true unless diff == 0
      end

      break unless had_non_zero
    end

    history_diffs.last << 0
    history_diffs.last.unshift 0

    history_diffs.reverse_each.skip(1).with_index do |row, i|
      row << row.last + history_diffs[history_diffs.size - 1 - i].last
      row.unshift row.first - history_diffs[history_diffs.size - 1 - i].first
    end

    suf_sum += history_diffs.first.last
    pre_sum += history_diffs.first.first
  end

  puts file, suf_sum, pre_sum
end

solve "example.txt"
puts
solve "input.txt"
