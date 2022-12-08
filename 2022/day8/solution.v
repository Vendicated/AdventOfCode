import os

fn main() {
	for file in os.args[1..] {
		tree_map := os.read_lines(file)!.map(it.split('').map(it.int()))
		w, h := tree_map[0].len, tree_map.len

		mut visible_trees := 0
		mut highest_score := 0

		for i in 0 .. h {
			for j in 0 .. w {
				mut score := 1
				mut counted := false

				for range in [[i - 1, -1, -1], [i + 1, h, 1]] {
					start, end, step := range[0], range[1], range[2]

					mut dir_score := 0
					mut visible := true

					for k := start; k != end; k += step {
						dir_score++
						if tree_map[k][j] >= tree_map[i][j] {
							visible = false
							break
						}
					}

					if visible && !counted {
						counted = true
						visible_trees++
					}

					score *= dir_score
				}

				for range in [[j - 1, -1, -1], [j + 1, w, 1]] {
					start, end, step := range[0], range[1], range[2]

					mut dir_score := 0
					mut visible := true

					for k := start; k != end; k += step {
						dir_score++
						if tree_map[i][k] >= tree_map[i][j] {
							visible = false
							break
						}
					}

					if visible && !counted {
						counted = true
						visible_trees++
					}

					score *= dir_score
				}

				if score > highest_score {
					highest_score = score
				}
			}
		}

		println('$file ~ Part 1: $visible_trees')
		println('$file ~ Part 2: $highest_score')
	}
}
