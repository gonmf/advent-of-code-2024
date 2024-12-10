input = File.read('10.input').split("\n").map(&:strip)

# problem 1

def count_trails(map, x, y, val = 0, reached = [])
  return 0 if x < 0 || y < 0 || x == map[0].size || y == map.size

  return 0 if map[y][x] != val

  if val == 9
    return 0 if reached.include?([x, y])

    reached.push([x, y])
    return 1
  end

  count_trails(map, x - 1, y, val + 1, reached) +
  count_trails(map, x + 1, y, val + 1, reached) +
  count_trails(map, x, y - 1, val + 1, reached) +
  count_trails(map, x, y + 1, val + 1, reached)
end

map = input.map { |line| line.chars.map(&:to_i) }

total = 0

map.each.with_index do |row, y|
  row.each.with_index do |val, x|
    total += count_trails(map, x, y) if val == 0
  end
end

puts total

# problem 2

def count_trails(map, x, y, val = 0)
  return 0 if x < 0 || y < 0 || x == map[0].size || y == map.size

  return 0 if map[y][x] != val

  return 1 if val == 9

  count_trails(map, x - 1, y, val + 1) +
  count_trails(map, x + 1, y, val + 1) +
  count_trails(map, x, y - 1, val + 1) +
  count_trails(map, x, y + 1, val + 1)
end

map = input.map { |line| line.chars.map(&:to_i) }

total = 0

map.each.with_index do |row, y|
  row.each.with_index do |val, x|
    total += count_trails(map, x, y) if val == 0
  end
end

puts total
