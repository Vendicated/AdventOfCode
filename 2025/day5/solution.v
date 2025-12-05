import os
import strconv
import arrays
import math

struct Range {
	start i64
	end   i64
}

fn Range.parse(s string) !Range {
	start, end := s.split_once('-') or { return error('failed to parse Range') }
	return Range{strconv.atoi64(start)!, strconv.atoi64(end)!}
}

fn (self Range) contains(v i64) bool {
	return v >= self.start && v <= self.end
}

fn (self Range) contains_range(other Range) bool {
	return self.contains(other.start) && self.contains(other.end)
}

fn solve(file string) ! {
	input := os.read_file(file)!

	ranges_section, ids_sections := input.split_once('\n\n') or { panic('invalid input') }

	mut ranges := ranges_section.split_into_lines().map(Range.parse(it)!)
	ids := string(ids_sections).split_into_lines().map(strconv.atoi64(it)!)

	// deduplicate ranges
	outer: for i := ranges.len - 1; i > 0; i-- {
		mut to_delete := []int{}

		defer {
			i -= to_delete.len
			for j in to_delete {
				ranges.delete(j)
			}
		}

		for j := i - 1; j >= 0; j-- {
			r1, r2 := ranges[i], ranges[j]

			if r2.contains_range(r1) {
				ranges.delete(i)
				continue outer
			}

			if r1.contains_range(r2) {
				to_delete << j
				continue
			}

			if !r1.contains(r2.start) && !r1.contains(r2.end) {
				continue
			}

			ranges[j] = Range{math.min(r1.start, r2.start), math.max(r1.end, r2.end)}
			ranges.delete(i)
			continue outer
		}
	}

	fresh_count := ids.count(fn [ranges] (id i64) bool {
		return ranges.any(it.contains(id))
	})
	fresh_ingredient_total := arrays.sum(ranges.map(it.end - it.start + 1))!

	println('${file}:\nPart 1: ${fresh_count}\nPart 2: ${fresh_ingredient_total}')
}

fn main() {
	solve('example.txt')!
	solve('input.txt')!
}
