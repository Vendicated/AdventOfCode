def solve(file : String)
  puts file

  left, right = [] of Int32, [] of Int32

  File.read_lines(file).each do |line|
    l, r = line.split
    left << l.to_i
    right << r.to_i
  end

  left.sort!
  right.sort!

  sum = left.zip(right).sum do |l, r|
    (l - r).abs
  end

  puts "Part 1: #{sum}"

  occurrences_in_right_list = right.tally

  similarity_score = left.sum do |x|
    x * (occurrences_in_right_list[x]? || 0)
  end

  puts "Part 2: #{similarity_score}"
end

solve "example.txt"
puts
solve "input.txt"
