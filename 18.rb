require 'set'

input = File.read('18.input').split("\n").map(&:strip)

@applied_bytes = Set.new
@remainder_bytes = Set.new

input.each.with_index do |line, i|
  if i < 1024
    @applied_bytes.add(line.split(',').map(&:to_i))
  else
    @remainder_bytes.add(line.split(',').map(&:to_i))
  end
end

@coord_width = 70 + 1
@coord_height = 70 + 1
best_path = nil

def solve
  visited = {}
  to_search = [[0, 0, 0, []]]

  while true
    curr = to_search.pop
    break if curr.nil?

    x, y, cost, path = curr

    visited_cost = visited["#{x},#{y}"]

    next if @applied_bytes.include?([x, y])

    if visited_cost.nil? || visited_cost > cost
      visited["#{x},#{y}"] = cost

      if x == @coord_width - 1 && y == @coord_height - 1
        best_path = path
      end
    else
      next
    end

    if x > 0
      to_search.unshift([x - 1, y, cost + 1, path + [[x - 1, y]]])
    end
    if y > 0
      to_search.unshift([x, y - 1, cost + 1, path + [[x, y - 1]]])
    end
    if x < @coord_width - 1
      to_search.push([x + 1, y, cost + 1, path + [[x + 1, y]]])
    end
    if y < @coord_height - 1
      to_search.push([x, y + 1, cost + 1, path + [[x, y + 1]]])
    end
  end

  cost = visited["#{@coord_width - 1},#{@coord_height - 1}"]

  [cost, best_path]
end

cost, path = solve

puts cost

# probleam 2

def solve
  visited = {}
  to_search = [[0, 0, 0, []]]

  while true
    curr = to_search.pop
    break if curr.nil?

    x, y, cost, path = curr

    visited_cost = visited["#{x},#{y}"]

    next if @applied_bytes.include?([x, y])

    if visited_cost.nil? || visited_cost > cost
      visited["#{x},#{y}"] = cost

      if x == @coord_width - 1 && y == @coord_height - 1
        return path
      end
    else
      next
    end

    if x > 0
      to_search.unshift([x - 1, y, cost + 1, path + [[x - 1, y]]])
    end
    if y > 0
      to_search.unshift([x, y - 1, cost + 1, path + [[x, y - 1]]])
    end
    if x < @coord_width - 1
      to_search.push([x + 1, y, cost + 1, path + [[x + 1, y]]])
    end
    if y < @coord_height - 1
      to_search.push([x, y + 1, cost + 1, path + [[x, y + 1]]])
    end
  end

  nil
end

last_path = path

@remainder_bytes.to_a.each do |new_byte|
  @applied_bytes.add(new_byte)

  next if !last_path.include?(new_byte)

  path = solve

  unless path
    puts new_byte.join(',')
    exit
  end

  last_path = path
end

