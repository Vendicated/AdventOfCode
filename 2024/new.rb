#!/usr/bin/ruby

require "dotenv/load"

require "net/http"
require "date"

day = ARGV[0] || Date.today.day

res = Net::HTTP.get URI("https://adventofcode.com/2024/day/#{day}/input"), { 
    "Cookie" => ENV["AOC_COOKIE"],
    "User-Agent" => "https://github.com/Vendicated/AdventOfCode <vendicated+aoc@riseup.net>"
}

folder = "day#{day}"

Dir.mkdir folder
File.write "#{folder}/example.txt", ""
File.write "#{folder}/input.txt", res

File.write "#{folder}/solution.cr", %Q(
def solve(file : String)
end

solve "example.txt"
puts
solve "input.txt"
).strip