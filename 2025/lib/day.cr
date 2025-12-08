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

abstract class BaseDay(T)
  abstract def parse_input(lines : Array(String)) : T

  @is_example = true

  def dbg(*args)
    puts *args if @is_example
  end

  def initialize
    _run "example.txt"
    @is_example = false
    _run "input.txt"
  end

  abstract def _run(file : String)
end

abstract class Day(T) < BaseDay(T)
  abstract def part1(input : T) : Printable
  abstract def part2(input : T) : Printable

  private def _run(file : String)
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

abstract class DaySingle(T) < BaseDay(T)
  abstract def run(input : T) : Tuple(Printable, Printable)

  private def _run(file : String)
    input = parse_input(File.read_lines file)

    solution1, solution2 = nil, nil

    elapsed = Time.measure do
      solution1, solution2 = run(input)
    end

    puts "#{file}: (#{format_time_span elapsed})"
    puts "Part 1: #{solution1} "
    puts "Part 2: #{solution2} "
  end
end
