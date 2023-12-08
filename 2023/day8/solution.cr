def solve(file : String)
  instructions, _, *network = File.read_lines(file)

  map = {} of String => Tuple(String, String)

  network.each do |line|
    source, destinations = line.split "="
    left, right = destinations.strip[1...-1].split(", ")
    map[source.strip] = {left, right}
  end

  puts file
  # solve1 instructions, map
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
  steps = 0_i64
  steps_total = 0_i64
  last_steps = 0_i64
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

  lowest_common_end = Int64::MAX

  # i suck at math so just brute force the common step count.
  # you can most definitely calculate this properly but lol
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
end

solve "example2.txt"
puts
solve "input.txt"
