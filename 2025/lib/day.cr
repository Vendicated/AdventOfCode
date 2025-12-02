alias Printable = String | Int32 | Int64

def format_time_span(span : Time::Span)
  secs = span.to_f
  millis = span.total_milliseconds
  micros = span.total_microseconds

  if secs >= 0.1
    "#{sprintf("%.2f", secs)}s"
  elsif secs >= 0.001
    "#{millis}ms"
  else
    "#{micros}µs"
  end
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
