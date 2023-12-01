def part1 file
    re = /\d/
    v = 0
    File.foreach file do |line|
        m = line.scan(re)
        v += Integer m.first + m.last
    end
    puts v
end

Nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

def parse(num)
    i = Nums.index num
    return String i + 1 unless i.nil?

    return num
end

def part2 file
    # normally, regex won't match overlapping matches:
    # "twone".scan(/two|one/) => ["two"]
    # this regex uses a lookahead with group to solve that
    re = /(?=(#{Nums.join "|"}|\d))/
    v = 0
    File.foreach file do |line|
        m = line.scan(re).flatten
        v += Integer parse(m.first) + parse(m.last)
    end
    puts v
end

puts "Example"
part1 "example.txt"
part2 "example2.txt"

puts "Input"
part1 "input.txt"
part2 "input.txt"
