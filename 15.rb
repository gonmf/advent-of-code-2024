require 'set'

input = File.read('15.input').split("\n").map(&:strip)

# problem 1

walls = Set.new
boxes = Set.new
robot = nil
movements = ''

input.each.with_index do |line, y|
  if line == '' && movements == ''
    movements = nil
    next
  end

  if movements.nil?
    movements = line
    next
  end

  if movements.size > 10
    movements = movements + line
  end

  line.chars.each.with_index do |c, x|
    if c == '#'
      walls.add([x, y])
    end

    if c == 'O'
      boxes.add([x, y])
    end

    if c == '@'
      robot = [x, y]
    end
  end
end

dir_offsets = {
  '<' => [-1, 0],
  '>' => [1, 0],
  '^' => [0, -1],
  'v' => [0, 1],
}

def push_box(pos, walls, boxes, dir_offset)
  offset_x, offset_y = dir_offset
  pos_x, pos_y = pos

  return if !boxes.include?([pos_x, pos_y])

  if boxes.include?([pos_x + offset_x, pos_y + offset_y])
    push_box([pos_x + offset_x, pos_y + offset_y], walls, boxes, dir_offset)
  end

  if !boxes.include?([pos_x + offset_x, pos_y + offset_y]) && !walls.include?([pos_x + offset_x, pos_y + offset_y])
    boxes.delete([pos_x, pos_y])
    boxes.add([pos_x + offset_x, pos_y + offset_y])
  end
end

movements.chars.each do |dir|
  dir_offset = dir_offsets[dir]
  offset_x, offset_y = dir_offset
  pos_x, pos_y = robot

  push_box([pos_x + offset_x, pos_y + offset_y], walls, boxes, dir_offset)

  if !boxes.include?([pos_x + offset_x, pos_y + offset_y]) && !walls.include?([pos_x + offset_x, pos_y + offset_y])
    robot = [pos_x + offset_x, pos_y + offset_y]
  end
end

total = 0

boxes.to_a.each do |box|
  x, y = box

  total += y * 100 + x
end

puts total

# problem 2

walls = Set.new
left_boxes = Set.new
right_boxes = Set.new
robot = nil
movements = ''

input.each.with_index do |line, y|
  if line == '' && movements == ''
    movements = nil
    next
  end

  if movements.nil?
    movements = line
    next
  end

  if movements.size > 10
    movements = movements + line
  end

  line.chars.each.with_index do |c, x|
    if c == '#'
      walls.add([x * 2, y])
      walls.add([x * 2 + 1, y])
    end

    if c == 'O'
      left_boxes.add([x * 2, y])
      right_boxes.add([x * 2 + 1, y])
    end

    if c == '@'
      robot = [x * 2, y]
    end
  end
end

def move_box(pos, left_boxes, right_boxes, dir_offset)
  offset_x, offset_y = dir_offset
  pos_x, pos_y = pos

  if left_boxes.include?([pos_x, pos_y])
    left_boxes.delete([pos_x, pos_y])
    left_boxes.add([pos_x + offset_x, pos_y + offset_y])
    right_boxes.delete([pos_x + 1, pos_y])
    right_boxes.add([pos_x + offset_x + 1, pos_y + offset_y])
    return
  end

  if right_boxes.include?([pos_x, pos_y])
    left_boxes.delete([pos_x - 1, pos_y])
    left_boxes.add([pos_x + offset_x - 1, pos_y + offset_y])
    right_boxes.delete([pos_x, pos_y])
    right_boxes.add([pos_x + offset_x, pos_y + offset_y])
    return
  end
end

def can_push(pos, walls, left_boxes, right_boxes, dir_offset)
  offset_x, offset_y = dir_offset
  pos_x, pos_y = pos

  return false if walls.include?([pos_x, pos_y])

  if offset_x != 0
    return false if walls.include?([pos_x + offset_x, pos_y])

    if left_boxes.include?([pos_x + offset_x, pos_y]) || right_boxes.include?([pos_x + offset_x, pos_y])
      return can_push([pos_x + offset_x, pos_y], walls, left_boxes, right_boxes, dir_offset)
    end
  else
    if left_boxes.include?([pos_x, pos_y])
      return can_push([pos_x, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset) && can_push([pos_x + 1, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
    end
    if right_boxes.include?([pos_x, pos_y])
      return can_push([pos_x, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset) && can_push([pos_x - 1, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
    end
  end

  return true
end

def push_box(pos, walls, left_boxes, right_boxes, dir_offset)
  offset_x, offset_y = dir_offset
  pos_x, pos_y = pos

  return unless can_push([pos_x, pos_y], walls, left_boxes, right_boxes, dir_offset)


  if offset_x != 0
    return if !left_boxes.include?([pos_x, pos_y]) && !right_boxes.include?([pos_x, pos_y])

    if left_boxes.include?([pos_x + offset_x, pos_y]) || right_boxes.include?([pos_x + offset_x, pos_y])
      push_box([pos_x + offset_x, pos_y], walls, left_boxes, right_boxes, dir_offset)
    end
  else
    if left_boxes.include?([pos_x, pos_y])
      push_box([pos_x, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
      push_box([pos_x + 1, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
    end
    if right_boxes.include?([pos_x, pos_y])
      push_box([pos_x - 1, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
      push_box([pos_x, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)
    end
  end

  move_box(pos, left_boxes, right_boxes, dir_offset)
end

movements.chars.each do |dir|
  dir_offset = dir_offsets[dir]
  offset_x, offset_y = dir_offset
  pos_x, pos_y = robot

  push_box([pos_x + offset_x, pos_y + offset_y], walls, left_boxes, right_boxes, dir_offset)

  if !left_boxes.include?([pos_x + offset_x, pos_y + offset_y]) && !right_boxes.include?([pos_x + offset_x, pos_y + offset_y]) && !walls.include?([pos_x + offset_x, pos_y + offset_y])
    robot = [pos_x + offset_x, pos_y + offset_y]
  end
end

total = 0

left_boxes.to_a.each do |box|
  x, y = box

  total += y * 100 + x
end

puts total
