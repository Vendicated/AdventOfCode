import os
import arrays

fn ctoi(c rune) u8 {
	return c - `0`
}

fn find_largest(line string, start int, end int) (u8, int) {
	mut largest := `0`
	mut largest_idx := -1

	for i in start .. end {
		c := line[i]
		if c > largest {
			largest = c
			largest_idx = i
		}
	}

	return largest, largest_idx
}

fn calc_joltage(line string, digits int) i64 {
	mut joltage := i64(0)
	mut idx := -1

	for i in 0 .. digits {
		mut digit := 0
		digit, idx = find_largest(line, idx + 1, line.len - (digits - i - 1))
		joltage = joltage * 10 + ctoi(digit)
	}

	return joltage
}

fn solve(file string) ! {
	lines := os.read_lines(file)!

	p1 := arrays.sum(lines.map(calc_joltage(it, 2)))!
	p2 := arrays.sum(lines.map(calc_joltage(it, 12)))!

	println('${file}:\nPart1: ${p1}\nPart2: ${p2}')
}

fn main() {
	solve('example.txt')!
	solve('input.txt')!
}
