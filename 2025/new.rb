#!/usr/bin/ruby

require "dotenv/load"

require "net/http"
require "date"

day = ARGV[0] || Date.today.day

res = Net::HTTP.get URI("https://adventofcode.com/2025/day/#{day}/input"), {
    "Cookie" => ENV["AOC_COOKIE"],
    "User-Agent" => "https://github.com/Vendicated/AdventOfCode <vendicated+aoc@riseup.net>"
}

folder = "day#{day}"

Dir.mkdir folder
File.write "#{folder}/example.txt", ""
File.write "#{folder}/input.txt", res

File.write "#{folder}/solution.cr", %Q(
require "../lib/day"

alias Input = Array(String)

class Day#{day} < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines
  end

  def part1(input) : Printable
    "TODO"
  end

  def part2(input) : Printable
    "TODO"
  end
end

Day#{day}.new

).strip
