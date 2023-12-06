def solve(file, is_part2 = false)
  res = 1
  times, distances = File.read_lines(file).map do |line|
    numbers = line.split(":").last.strip
    if is_part2
      [numbers.gsub(" ", "").to_i64]
    else
      numbers.split(/\s+/).map { |n| n.to_i64 }
    end
  end

  res = 1
  times.each_with_index do |totalTime, idx|
    first_winning = (1i64...totalTime).bsearch do |t|
      t * (totalTime - t) > distances[idx]
    end

    last_winning = totalTime.step(by: -1, to: 1).to_a.bsearch do |t|
      t * (totalTime - t) > distances[idx]
    end

    next if first_winning.nil? || last_winning.nil?

    res *= last_winning - first_winning + 1
  end

  res

  puts res
end

puts "example.txt"
solve "example.txt"
solve "example.txt", true
puts

puts "input.txt"
solve "input.txt"
solve "input.txt", true
