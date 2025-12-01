alias Printable = String | Int32

def format_time_span(span : Time::Span)
  amounts = [
    {span.minutes, "m"},
    {span.seconds, "s"},
    {span.microseconds, "µs"},
  ]

  amounts
    .select { |a| a[0] > 0 }
    .map { |a| a.join "" }
    .join " "
end

abstract class Day(T)
  abstract def parse_input(lines : Array(String)) : T

  abstract def part1(input : T) : Printable
  abstract def part2(input : T) : Printable

  def initialize
    run "example.txt"
    run "input.txt"
  end

  private def run(file : String)
    input = parse_input(File.read_lines file)
    input2 = input.clone

    solution1 : Printable? = nil
    solution2 : Printable? = nil

    elapsed1 = Time.measure do
      solution1 = part1(input)
    end
    elapsed2 = Time.measure do
      solution2 = part2(input2)
    end

    puts "#{file}:"
    puts "Part 1: #{solution1} (#{format_time_span elapsed1})"
    puts "Part 2: #{solution2} (#{format_time_span elapsed2})"
  end
end
