# OH MY FUCKING GOD I SPENT LIKE HALF AN HOUR DEBUGGING ONLY TO EVENTUALLY REALISE THAT THE FIX WAS:
# ```diff
# -  unmapped_ranges.each do |range|
# +  unmapped_ranges.clone.each do |range|
# ```
#
# ITS SO OVER

def solve(file)
  smallest_location_number = UInt64::MAX

  lines = File.read_lines(file)
  seeds = lines.shift.split(":").last.strip.split(" ").map { |s| s.to_u64 }

  did_map = false
  seeds.each do |seed|
    number = seed

    lines.each do |line|
      if line.ends_with? "map:"
        did_map = false
        next
      end
      next if did_map || line.empty?

      dest_range_start, source_range_start, range_length = line.split(" ").map { |s| s.to_u64 }

      if number >= source_range_start && number < source_range_start + range_length
        number = dest_range_start + (number - source_range_start)
        did_map = true
      end
    end

    smallest_location_number = [smallest_location_number, number].min
  end

  puts smallest_location_number
end

def solve2(file)
  smallest_location_number = UInt64::MAX

  lines = File.read_lines(file)
  seeds = lines.shift.split(":").last.strip.split(" ").map { |s| s.to_u64 }

  (0...seeds.size).step(by: 2) do |i|
    unmapped_ranges = [{seeds[i], seeds[i] + seeds[i + 1] - 1}]
    mapped_ranges = [] of Tuple(UInt64, UInt64)

    lines.each do |line|
      if line.empty? || line.ends_with? "map:"
        unmapped_ranges += mapped_ranges
        mapped_ranges = [] of Tuple(UInt64, UInt64)
        next
      end

      dest_range_start, source_range_start, range_length = line.split(" ").map { |s| s.to_u64 }

      map_start = source_range_start
      map_end = source_range_start + range_length - 1

      unmapped_ranges.clone.each do |range|
        seed_start, seed_end = range
        next if seed_start > map_end || seed_end < map_start

        unmapped_ranges.delete range

        # if the left side of the seed is fully contained in the map
        if seed_start >= map_start
          new_start = dest_range_start + (seed_start - map_start)

          # if the seed is fully contained in the map
          if map_end >= seed_end
            mapped_ranges << {new_start, dest_range_start + (seed_end - map_start)}
          else
            mapped_ranges << {new_start, dest_range_start + (map_end - map_start)}
            unmapped_ranges << {map_end + 1, seed_end}
          end

          # if the left side of the seed is not fully contained
        else
          unmapped_ranges << {seed_start, map_start - 1}
          new_start = dest_range_start

          # if the right side is fully contained
          if map_end >= seed_end
            mapped_ranges << {new_start, dest_range_start + (seed_end - map_start)}

            # if neither sides of the seed are fully contained
          else
            mapped_ranges << {new_start, dest_range_start + (map_end - map_start)}
            unmapped_ranges << {map_end + 1, seed_end}
          end
        end
      end
    end

    ranges = unmapped_ranges + mapped_ranges

    smallest_location_number = [
      smallest_location_number,
      ranges.map { |r| r[0] }.min,
    ].min
  end

  puts smallest_location_number
end

puts "example.txt"
solve "example.txt"
solve2 "example.txt"

puts

puts "input.txt"
solve "input.txt"
solve2 "input.txt"
