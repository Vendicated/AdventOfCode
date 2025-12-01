require "../lib/day"

alias Input = Array(String)

class Day1 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines
  end

  def part1(input) : Printable
    password = 0
    dial = 50
    input.each do |line|
      direction = line[0] == 'R' ? 1 : -1
      n = line[1..].to_i
      dial = (dial + direction * n + 100) % 100

      password += 1 if dial == 0
    end

    password
  end

  # i tried doing with math instead of brute force but i'm too dumb (i probably had some off by one error somewhere and couldn't figure it out)
  def part2(input) : Printable
    password = 0
    dial = 50
    input.each do |line|
      direction = line[0] == 'R' ? 1 : -1
      n = line[1..].to_i
      n.times do
        dial += direction
        case dial
        when 0
          password += 1
        when 100
          dial = 0
          password += 1
        when -1
          dial = 99
        end
      end
    end

    password
  end
end

Day1.new
