require 'set'

input = File.read('20.input').split("\n").map(&:strip)

# problem 1

track_coords = Set.new
start = nil
goal = nil

input.each.with_index do |line, y|
  line.chars.each.with_index do |c, x|
    if c == 'S'
      start = [x, y]
      track_coords.add([x, y])
    elsif c == 'E'
      goal = [x, y]
      track_coords.add([x, y])
    elsif c == '.'
      track_coords.add([x, y])
    end
  end
end

visited = Set.new
track_path = [start]

pos = start

while pos != goal
  visited.add(pos)
  x, y = pos

  [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
  ].each do |offsets|
    offset_x, offset_y = offsets

    new_x = x + offset_x
    new_y = y + offset_y

    if track_coords.include?([new_x, new_y]) && !visited.include?([new_x, new_y])
      pos = [new_x, new_y]

      track_path.push(pos)
      break
    end
  end
end

visited = Set.new
total = 0

track_indexes = {}

track_path.each.with_index do |pos, idx|
  track_indexes[pos] = idx
end

track_path.each.with_index do |pos, idx|
  visited.add(pos)

  x, y = pos

  [
    [2, 0],
    [-2, 0],
    [0, 2],
    [0, -2],
  ].each do |offsets|
    offset_x, offset_y = offsets

    new_x = x + offset_x
    new_y = y + offset_y

    new_idx = track_indexes[[new_x, new_y]]
    next if new_idx.nil? || new_idx < idx

    savings = new_idx - idx - 2

    total += 1 if savings >= 100
  end
end

puts total

# problem 2

total = 0

def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

track_path.each.with_index do |pos1, idx1|
  track_path.each.with_index do |pos2, idx2|
    next if idx1 >= idx2

    dist = distance(pos1, pos2)
    next if distance(pos1, pos2) > 20

    savings = idx2 - idx1 - dist

    total += 1 if savings >= 100
  end
end

puts total
