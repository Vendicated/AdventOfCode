def parseNums line
    line.strip.split(" ").map { |n| n.strip.to_i } 
end

def solve file
    points = 0

    cardsWon = []

    File.foreach(file).with_index do |line, idx|
        cardsWon[idx] ||= 1

        left, right = line.split " | "

        winning = parseNums left.split(":")[1]
        owned = parseNums right

        winningCardCount = owned.count { |n| winning.include? n }
        next if winningCardCount == 0

        for i in 1..winningCardCount do
            cardsWon[idx + i] ||= 1
            cardsWon[idx + i] += cardsWon[idx]
        end

        points += 2 ** (winningCardCount - 1)
    end

    puts file, points, cardsWon.reduce { |a, b| a + b }
end

solve "example.txt"
puts
solve "input.txt"