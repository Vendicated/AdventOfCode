def solve file
    idsum = 0
    powerSum = 0

    File.foreach file do |line|
        left, right = line.split ":"
        _, id = left.split " "

        cubesShown = {
            "red" => 0,
            "green" => 0,
            "blue" => 0
        }

        rounds = right.strip.split ";"
        rounds.each do |round|
            cubes = round.split ","
            cubes.each do |cube|
                amount, color = cube.strip.split " "
                cubesShown[color] = [cubesShown[color], amount.to_i].max
            end
        end

        if cubesShown["red"] <= 12 and cubesShown["green"] <= 13 and cubesShown["blue"] <= 14
            idsum += id.to_i
        end

        powerSum += cubesShown["red"] * cubesShown["green"] * cubesShown["blue"]
    end

    puts "#{file}",
         "Part 1: #{idsum}",
         "Part 2: #{powerSum}",
         nil
end

solve "example.txt"
solve "input.txt"
