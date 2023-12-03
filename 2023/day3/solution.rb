def isSymbol c
    c != "." and (c > "9" || c < "0")
end

def solve file
    sum = 0
    gearRatioSum = 0
    gearMap = {}
    
    lines = File.readlines file, chomp: true

    lines.each_with_index do |line, idx|
        currIdx = 0
        loop {
            start = line.index /\d/, currIdx
            break if start.nil?

            _end = line.index(/\D|$/, start) || start
            currIdx = _end + 1

            num = line[start.._end-1].to_i

            didAdd = false
            for i in start-1.._end do
                for j in idx-1..idx+1 do
                    if !lines[j] or !lines[j][i]
                        next
                    end

                    if !didAdd and isSymbol lines[j][i]
                        sum += num
                        didAdd = true
                    end

                    if lines[j][i] == "*"
                        gear = gearMap[[j, i]] ||= {
                            :adjacentNums => 0,
                            :gearRatio => 1
                        }

                        gear[:adjacentNums] += 1
                        gear[:gearRatio] *= num
                    end
                end
            end
        }
    end

    for gear in gearMap.values do
        gearRatioSum += gear[:gearRatio] if gear[:adjacentNums] == 2
    end
    
    puts file, sum, gearRatioSum
end

solve "example.txt"
puts
solve "input.txt"