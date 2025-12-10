require "../lib/day"

alias Input = Array(Line)

record Line, lights : Array(Int32), buttons : Array(Array(Int32)), joltage_requirements : Array(Int32)

class Day10 < Day(Input)
  def parse_input(lines : Array(String)) : Input
    lines.map do |line|
      elements = line.split ' '
      light_diagram = elements.shift.chars.skip 1
      lights = light_diagram.each_index.select { |i| light_diagram[i] == '#' }.to_a
      joltage = elements.pop[1...-1].split(',').map &.to_i
      buttons = elements.map do |e|
        e[1...-1].split(',').map &.to_i
      end

      Line.new lights, buttons, [0]
    end
  end

  def part1(input) : Printable
    sum = 0
    input.each do |line|
      lights = line.lights

      if line.buttons.any? { |b| b == lights }
        sum += 1
        next
      end

      i = 1
      buttons = Set.new line.buttons
      done = false

      loop do
        i += 1

        new_buttons = Set(Array(Int32)).new
        buttons.each do |b1|
          break if done
          line.buttons.each do |b2|
            next if b1 == b2
            diff = (b1 | b2) - (b1 & b2)

            unless diff.empty?
              diff.sort!
              if diff == lights
                done = true
                break
              end
              new_buttons << diff
            end
          end
        end

        if done
          sum += i
          break
        end

        buttons = new_buttons
      end
    end

    sum
  end

  def part2(input) : Printable
    "TODO"
  end
end

Day10.new
