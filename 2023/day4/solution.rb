def parseNums line
    line.strip.split(" ").map { |n| n.strip.to_i } 
end

def solve file
    points = 0

    cardsWon = 0
    cardsWonBuf = []

    File.foreach(file).each do |line|
        cardsWonBuf[0] ||= 1

        left, right = line.split " | "

        winning = parseNums left.split(":")[1]
        owned = parseNums right

        winningCardCount = owned.count { |n| winning.include? n }
        if winningCardCount == 0
            cardsWon += cardsWonBuf.shift
            next
        end

        for i in 1..winningCardCount do
            cardsWonBuf[i] ||= 1
            cardsWonBuf[i] += cardsWonBuf[0]
        end

        points += 2 ** (winningCardCount - 1)

        cardsWon += cardsWonBuf.shift
    end

    puts file, points, cardsWon
end

solve "example.txt"
puts
solve "input.txt"
puts
solve "input-100k.txt"
puts
solve "input-1m.txt"