def hash(s : String)
  s.chars.reduce(0) { |acc, curr| (acc + curr.ord) * 17 % 256 }
end

def solve(file : String)
  steps = File.read(file).strip.split ','

  step_hash_sum = steps.reduce(0) { |acc, curr| acc + hash curr }

  boxes = StaticArray(Array(Tuple(String, Int32)), 256).new { [] of Tuple(String, Int32) }

  steps.each do |step|
    if step.ends_with? '-'
      label = step[...-1]
      boxes[hash label].reject! { |e| e[0] == label }
    else
      label, focal_length = step.split '='
      box = boxes[hash label]
      i = box.index { |e| e[0] == label }
      if i
        box[i] = {label, focal_length.to_i}
      else
        box << {label, focal_length.to_i}
      end
    end
  end

  focusing_power = 0
  boxes.each_with_index do |box, box_num|
    box.each_with_index do |(label, focal_length), slot_num|
      focusing_power += (box_num + 1) * (slot_num + 1) * focal_length
    end
  end

  puts file, step_hash_sum, focusing_power
end

solve "example.txt"
puts
solve "input.txt"
