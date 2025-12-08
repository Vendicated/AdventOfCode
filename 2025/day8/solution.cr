require "../lib/day"

record Point3D, x : Int64, y : Int64, z : Int64 do
  def distance(p2 : Point3D)
    Math.sqrt((x - p2.x) ** 2 + (y - p2.y) ** 2 + (z - p2.z) ** 2)
  end
end

record Pair, p1 : Point3D, p2 : Point3D, distance : Float64

alias Input = Array(Point3D)

class Day8 < DaySingle(Input)
  def parse_input(lines : Array(String)) : Input
    lines.map do |line|
      x, y, z = line.split(',').map &.to_i
      Point3D.new x, y, z
    end
  end

  def run(input) : {Printable, Printable}
    pairs = [] of Pair

    shortest_distance = Int32::MAX
    input.each_combination(2, true) do |pair|
      p1, p2 = pair.unsafe_fetch(0), pair.unsafe_fetch(1)
      distance = p1.distance(p2)
      # Don't consider distances that are too large
      if distance < shortest_distance
        shortest_distance = distance
      elsif distance > shortest_distance * 20
        next
      end

      pairs << Pair.new p1, p2, distance
    end

    pairs.unstable_sort! { |a, b| a.distance <=> b.distance }

    n = @is_example ? 10 : 1000

    circuits = [] of Array(Point3D)

    p1 = 0
    p2 = 0
    i = 0
    pairs.each do |pair|
      c1, c2 = circuits.index(&.includes? pair.p1), circuits.index(&.includes? pair.p2)

      if c1.nil? && c2.nil?
        circuits << [pair.p1, pair.p2]
      elsif !c1.nil? && !c2.nil?
        if c1 != c2
          circuits.unsafe_fetch(c1).concat circuits.unsafe_fetch(c2)
          circuits.delete_at c2
        end
      elsif !c1.nil?
        circuits.unsafe_fetch(c1) << pair.p2
      else
        circuits.unsafe_fetch(c2.not_nil!) << pair.p1
      end

      i += 1
      if i == n
        p1 = circuits.sort_by!(&.size).last(3).product(&.size)
      end

      if circuits.size == 1 && circuits.unsafe_fetch(0).size == input.size
        p2 = pair.p1.x * pair.p2.x
        break
      end
    end

    {p1, p2}
  end
end

Day8.new
