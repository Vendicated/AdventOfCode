import os

const paper_roll = `@`
const empty = `.`

fn calculate_accessible_rolls(grid [][]u8, with_remove bool) int {
	mut accessible_rolls := 0

	for {
		mut had_accessible := false

		for i in 0 .. grid.len {
			mut row := grid[i]
			for j in 0 .. row.len {
				if row[j] == empty {
					continue
				}

				mut rolls_adjacent := 0

				for i2 in i - 1 .. i + 2 {
					for j2 in j - 1 .. j + 2 {
						if (i == i2 && j == j2)
							|| (i2 >= grid.len || i2 < 0 || j2 >= row.len || j2 < 0) {
							continue
						}
						if grid[i2][j2] == paper_roll {
							rolls_adjacent++
						}
					}
				}
				if rolls_adjacent < 4 {
					accessible_rolls++
					had_accessible = true
					if with_remove {
						row[j] = empty
					}
				}
			}
		}

		if !with_remove || !had_accessible {
			return accessible_rolls
		}
	}

	return 0
}

fn solve(file string) ! {
	lines := os.read_lines(file)!

	grid := lines.map(it.bytes())

	p1 := calculate_accessible_rolls(grid, false)
	p2 := calculate_accessible_rolls(grid, true)
	println('${file}:\nPart1: ${p1}\nPart2: ${p2}')
}

fn main() {
	solve('example.txt')!
	solve('input.txt')!
}
