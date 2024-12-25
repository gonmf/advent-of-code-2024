input = File.read('25.input').split("\n").map(&:strip)

group = []
keys = []
locks = []

def convert_to_height_array(group)
  heights = Array.new(5, -1)

  group.each do |row|
    row.each.with_index do |c, idx|
      if c == '#'
        heights[idx] += 1
      end
    end
  end

  heights
end

input.each do |line|
  if line.size > 0
    group.push(line.chars)

    if group.size == 7
      if group[0].all? { |c| c == '#' }
        locks.push(convert_to_height_array(group))
      else
        keys.push(convert_to_height_array(group))
      end
      group = []
    end
  end
end

total = 0

keys.each do |key|
  locks.each do |lock|
    overlap = false

    (0...5).each do |i|
      if key[i] + lock[i] >= 6
        overlap = true
        break
      end
    end

    total += 1 unless overlap
  end
end

puts total
