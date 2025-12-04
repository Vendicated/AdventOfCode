import os

fn ctoi(c rune) int {
	if c < `0` || c > `9` {
		panic('char not a number')
	}

	return u8(c - `0`)
}

fn find_largest(line string, start int, end int) (u8, int) {
	mut largest := `0`
	mut largest_idx := -1

	for i := start; i < end; i++ {
		c := line[i]
		if c > largest {
			largest = c
			largest_idx = i
		}
	}

	if largest_idx == -1 {
		panic('not found')
	}

	return largest, largest_idx
}

fn calc_joltage(line string, digits int) i64 {
	mut joltage := i64(0)
	mut idx := 0

	for i in 0 .. digits {
		digit, new_idx := find_largest(line, idx, line.len - (digits - i - 1))
		joltage = joltage * 10 + ctoi(digit)
		idx = new_idx + 1
	}

	return joltage
}

fn solve(file string) ! {
	lines := os.read_lines(file)!

	mut total_output_joltage := i64(0)
	mut total_output_joltage_p2 := i64(0)

	for line in lines {
		total_output_joltage += calc_joltage(line, 2)
		total_output_joltage_p2 += calc_joltage(line, 12)
	}

	println('${file}:\nPart1: ${total_output_joltage}\nPart2: ${total_output_joltage_p2}')
}

fn main() {
	solve('example.txt')!
	solve('input.txt')!
}
