require 'set'

input = File.read('06.input').split("\n").map(&:strip)

# problem 1

visited = Set.new
@blocks = Set.new
guard_x = nil
guard_y = nil
guard_dir = '^'

@dir_offsets = {
  '^' => [0, -1],
  'v' => [0, 1],
  '<' => [-1, 0],
  '>' => [1, 0],
}

@next_dir = {
  '^' => '>',
  '>' => 'v',
  'v' => '<',
  '<' => '^',
}

@width = input[0].size
@height = input.size

input.each.with_index do |line, y|
  line.chars.each.with_index do |c, x|
    if c == '#'
      @blocks.add([x, y])
    elsif c == '^'
      guard_x = x
      guard_y = y
    end
  end
end

orig_guard_x = guard_x
orig_guard_y = guard_y

while true
  visited.add([guard_x, guard_y])

  offset_x, offset_y = @dir_offsets[guard_dir]

  new_guard_x = guard_x + offset_x
  new_guard_y = guard_y + offset_y

  break if new_guard_x < 0 || new_guard_y < 0 || new_guard_x == @width || new_guard_y == @height

  if @blocks.include?([new_guard_x, new_guard_y])
    guard_dir = @next_dir[guard_dir]
    next
  end

  guard_x = new_guard_x
  guard_y = new_guard_y
end

puts visited.size

# problem 2

def on_a_loop(guard_x, guard_y, guard_dir, newly_blocked)
  visited = Set.new

  while true
    if visited.include?([guard_x, guard_y, guard_dir])
      return true
    else
      visited.add([guard_x, guard_y, guard_dir])
    end

    offset_x, offset_y = @dir_offsets[guard_dir]

    new_guard_x = guard_x + offset_x
    new_guard_y = guard_y + offset_y

    return false if new_guard_x < 0 || new_guard_y < 0 || new_guard_x == @width || new_guard_y == @height

    if @blocks.include?([new_guard_x, new_guard_y]) || [new_guard_x, new_guard_y] == newly_blocked
      guard_dir = @next_dir[guard_dir]
      next
    end

    guard_x = new_guard_x
    guard_y = new_guard_y
  end
end

total = 0

visited.to_a.each do |blocked_pos|
  if on_a_loop(orig_guard_x, orig_guard_y, '^', blocked_pos)
    total += 1
  end
end

puts total
