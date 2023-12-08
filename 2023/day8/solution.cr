def solve(file : String)
  instructions, _, *network = File.read_lines(file)

  map = {} of String => Tuple(String, String)

  network.each do |line|
    source, destinations = line.split "="
    left, right = destinations.strip[1...-1].split(", ")
    map[source.strip] = {left, right}
  end

  puts file
  solve1 instructions, map
  solve2 instructions, map
end

def solve1(instructions : String, map : Hash(String, Tuple(String, String)))
  curr_node = "AAA"
  steps = 0
  loop do
    instructions.each_char do |c|
      steps += 1
      curr_node = map[curr_node][c == 'L' ? 0 : 1]

      break if curr_node == "ZZZ"
    end
    break if curr_node == "ZZZ"
  end

  puts steps
end

def find_step_count_til_cycle(node : String, instructions : String, map : Hash(String, Tuple(String, String))) : Int64
  steps = steps_total = last_steps = 0_i64
  curr_node = node

  loop do
    instructions.each_char do |c|
      steps += 1
      curr_node = map[curr_node][c == 'L' ? 0 : 1]
    end

    if curr_node == node
      return steps if steps == last_steps

      steps_total += steps
      last_steps = steps_total
      steps = 0_i64
    end
  end
end

def solve2(instructions : String, map : Hash(String, Tuple(String, String)))
  start_nodes = map.keys.select! { |k| k.ends_with? 'A' }

  start_nodes_end_steps = [] of Array(Tuple(Int64, Int64))

  start_nodes.each_with_index do |node, idx|
    curr_node = node
    steps = 0_i64
    end_steps = [] of Tuple(Int64, Int64)
    start_nodes_end_steps << end_steps

    visited = Set(String).new

    while !visited.includes? curr_node
      visited.add curr_node
      instructions.each_char do |c|
        steps += 1

        curr_node = map[curr_node][c == 'L' ? 0 : 1]

        if curr_node.ends_with? 'Z'
          steps_til_cycle = find_step_count_til_cycle curr_node, instructions, map
          end_steps << {steps, steps_til_cycle}
        end
      end
    end
  end

  # the input is made for LCM. however, my solution is made to cover all inputs.
  # for each starting node, i first find the reachable end node(s) and how many steps (x) are needed to get there
  # for each end node, i calculate how many steps are needed to loop back to the same end node (y)
  # (in the case of the AOC input, x = y, hence why LCM works)
  # now that we have this info, we just need to take the first starting node (x_1), and calculate how often
  # we need to add the corresponding loop step count (y_1) to it, until the difference between x_1 and all
  # other starting nodes (x_n) is divisable by the loop step count of those nodes (y_n).
  # supposedly this is solvable mathematically via the "chinese remainder theorem" (of which i have never heard of before lol),
  # but the below brute force approach runs relatively fast (~10s) and is much simpler
  # to brute force it, the below code just keeps adding y_1 to x_1 until the above specified condition is satisfied

  lowest_common_end = Int64::MAX

  start_nodes_end_steps.first.each do |steps|
    steps_til_end, steps_til_loop = steps

    steps = steps_til_end
    loop do
      if start_nodes_end_steps.skip(1).all? { |s| s.any? { |n| (steps - n[0]) % n[1] == 0 } }
        lowest_common_end = [lowest_common_end, steps].min
        break
      end
      steps += steps_til_loop
    end
  end

  puts lowest_common_end

  # LCM solution
  # puts start_nodes_end_steps.reduce(1_i64) { |acc, curr| acc.lcm curr[0][0] }
end

solve "example.txt"
puts
solve "input.txt"
