require 'set'

input = File.read('16.input').split("\n").map(&:strip)

# problem 1

walls = Set.new
goal = nil
start = nil

input.each.with_index do |line, y|
  line.chars.each.with_index do |c, x|
    if c == '#'
      walls.add([x, y])
      next
    end

    if c == 'S'
      start = [x, y]
      next
    end

    if c == 'E'
      goal = [x, y]
      next
    end
  end
end

def search(start, goal, walls, known_best_cost)
  dir_offsets = {
    '^' => [0, -1],
    'v' => [0, 1],
    '<' => [-1, 0],
    '>' => [1, 0],
  }

  rotations = {
    '^' => ['<', '>'],
    'v' => ['<', '>'],
    '<' => ['^', 'v'],
    '>' => ['^', 'v'],
  }

  x, y = start
  to_search = [[x, y, '>', 0, [start]]]
  key = [x, y, '>'].join(',')
  visited = {}
  visited[key] = 0
  best_cost = known_best_cost
  best_seats = Set.new
  best_seats.add(start)
  best_seats.add(goal)

  while to_search.size > 0
    move = to_search.pop

    x, y, dir, cost, path = move
    next if !best_cost.nil? && cost >= best_cost
    next if !known_best_cost.nil? && cost >= known_best_cost

    offset_x, offset_y = dir_offsets[dir]
    new_x = x + offset_x
    new_y = y + offset_y

    if !walls.include?([new_x, new_y])
      if goal[0] == new_x && goal[1] == new_y
        if best_cost.nil? || best_cost > cost + 1
          best_cost = cost + 1
        end

        if !known_best_cost.nil? && known_best_cost == cost + 1
          path.each do |pos|
            best_seats.add(pos)
          end
        end
      end

      key = [new_x, new_y, dir].join(',')

      past_cost = visited[key]
      if past_cost.nil? || past_cost >= cost + 1
        visited[key] = cost + 1
        to_search.unshift([new_x, new_y, dir, cost + 1, path + [[new_x, new_y]]])
      end
    end

    rotations[dir].each do |other_dir|
      key = [x, y, other_dir].join(',')

      past_cost = visited[key]
      if past_cost.nil? || past_cost >= cost + 1000
        visited[key] = cost + 1000
        to_search.push([x, y, other_dir, cost + 1000, path])
      end
    end
  end

  [best_cost, best_seats]
end

best_cost, = search(start, goal, walls, nil)

puts best_cost

# problem 2

_, best_seats = search(start, goal, walls, best_cost)

puts best_seats.size
