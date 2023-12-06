require "big"

def parseNums(line)
  line.strip.split(/\s+/).map { |n| n.strip.to_i }
end

def solve(file)
  startTime = Time.utc

  points = 0

  cardsWon = BigInt.new(0)
  cardsWonBuf = StaticArray(BigInt, 20).new(BigInt.new(1))

  File.each_line(file) do |line|
    left, right = line.split " | "

    winning = parseNums left.split(":")[1]
    owned = parseNums right

    winningCardCount = owned.count { |n| winning.includes? n }
    if winningCardCount == 0
      cardsWon += cardsWonBuf[0]
      cardsWonBuf[0] = BigInt.new(1)
      cardsWonBuf.rotate!(1)
      next
    end

    (1..winningCardCount).each do |i|
      cardsWonBuf[i] += cardsWonBuf[0]
    end

    points += 2 ** (winningCardCount - 1)

    cardsWon += cardsWonBuf[0]
    cardsWonBuf[0] = BigInt.new(1)
    cardsWonBuf.rotate!(1)
  end

  puts file, points, cardsWon, "took #{(Time.utc - startTime).total_milliseconds}ms"
end

solve "example.txt"
puts
solve "input.txt"
puts
solve "input-100k.txt"
puts
solve "input-1m.txt"
