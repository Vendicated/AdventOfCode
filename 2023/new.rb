require "dotenv/load"

require "net/http"

day = ARGV[0]

res = Net::HTTP.get URI("https://adventofcode.com/2023/day/#{day}/input"), { 
    "Cookie" => ENV["AOC_COOKIE"],
    "User-Agent" => "https://codeberg.org/Ven/AdventOfCode <vendicated@riseup.net>"
}

folder = "day#{day}"

Dir.mkdir folder
File.write "#{folder}/example.txt", ""
File.write "#{folder}/input.txt", res
File.write "#{folder}/solution.rb", %Q(
def solve file
end

solve "example.txt"
puts
solve "input.txt"
).strip