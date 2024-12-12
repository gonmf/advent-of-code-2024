require 'set'

input = File.read('12.input').split("\n").map(&:strip)

# problem 1

map = input.map { |line| line.chars.map(&:ord) }

def fill_in_unique(map, x, y, v, c)
  return if map.dig(y, x) != v

  map[y][x] = c

  fill_in_unique(map, x - 1, y, v, c) if x > 0
  fill_in_unique(map, x + 1, y, v, c) if x < map[0].size - 1
  fill_in_unique(map, x, y - 1, v, c) if y > 0
  fill_in_unique(map, x, y + 1, v, c) if y < map.size - 1
end

c = 100
map.each.with_index do |line, y|
  line.each.with_index do |v, x|
    if v < 100
      fill_in_unique(map, x, y, v, c)
      c = c + 1
    end
  end
end

def search(map, x, y, visited, areas, perimeters)
  to_expand = [[x, y]]

  while to_expand.size > 0
    x, y = to_expand.pop

    next if visited.include?("#{x},#{y}")

    visited.add("#{x},#{y}")

    v = map.dig(y, x)

    areas[v] = (areas[v] || 0) + 1

    if x == 0 || map.dig(y, x - 1) != v
      perimeters[v] = (perimeters[v] || 0) + 1
    end
    if x == map[0].size - 1 || map.dig(y, x + 1) != v
      perimeters[v] = (perimeters[v] || 0) + 1
    end
    if y == 0 || map.dig(y - 1, x) != v
      perimeters[v] = (perimeters[v] || 0) + 1
    end
    if y == map.size - 1 || map.dig(y + 1, x) != v
      perimeters[v] = (perimeters[v] || 0) + 1
    end

    if x > 0
      to_expand.push([x - 1, y])
    end
    if x < map[0].size - 1
      to_expand.push([x + 1, y])
    end
    if y > 0
      to_expand.push([x, y - 1])
    end
    if y < map.size - 1
      to_expand.push([x, y + 1])
    end
  end
end

areas = {}
perimeters = {}

search(map, 0, 0, Set.new, areas, perimeters)

puts (areas.keys.map { |key| areas[key] * perimeters[key] }).sum

# problem 2

def lowest(map, pos, vs, shift)
  shift_x, shift_y = shift

  x, y = pos
  val = map.dig(y, x)
  new_x = x + shift_x
  new_y = y + shift_y

  return pos if new_x < 0 || new_y < 0 || new_x == map[0].size || new_y == map.size

  vs_x, vs_y = vs
  new_vs_x = vs_x + shift_x
  new_vs_y = vs_y + shift_y

  return pos if new_vs_x < 0 || new_vs_y < 0 || new_vs_x == map[0].size || new_vs_y == map.size

  return pos if map.dig(new_vs_y, new_vs_x) == val
  return pos if map.dig(new_y, new_x) != val

  lowest(map, [new_x, new_y], [new_vs_x, new_vs_y], shift)
end

def lowest_border(map, pos, shift)
  shift_x, shift_y = shift

  x, y = pos
  val = map.dig(y, x)
  new_x = x + shift_x
  new_y = y + shift_y

  return pos if new_x < 0 || new_y < 0 || new_x == map[0].size || new_y == map.size

  return pos if map.dig(new_y, new_x) != val

  lowest_border(map, [new_x, new_y], shift)
end

def count_sides(map, sides)
  sides_considered = Set.new

  map.each.with_index do |row, y|
    row.each.with_index do |v, x|
      if x == 0
        pos_x, pos_y = lowest_border(map, [x, y], [0, -1])
        visit_key = "#{pos_x},#{pos_y},#{v},x-"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      elsif map.dig(y, x - 1) != v
        pos_x, pos_y = lowest(map, [x, y], [x - 1, y], [0, -1])
        visit_key = "#{pos_x},#{pos_y},#{v},x-"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      end

      if x == map[0].size - 1
        pos_x, pos_y = lowest_border(map, [x, y], [0, -1])
        visit_key = "#{pos_x},#{pos_y},#{v},x+"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      elsif map.dig(y, x + 1) != v
        pos_x, pos_y = lowest(map, [x, y], [x + 1, y], [0, -1])
        visit_key = "#{pos_x},#{pos_y},#{v},x+"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      end

      if y == 0
        pos_x, pos_y = lowest_border(map, [x, y], [-1, 0])
        visit_key = "#{pos_x},#{pos_y},#{v},y-"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      elsif map.dig(y - 1, x) != v
        pos_x, pos_y = lowest(map, [x, y], [x, y - 1], [-1, 0])
        visit_key = "#{pos_x},#{pos_y},#{v},y-"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      end

      if y == map.size - 1
        pos_x, pos_y = lowest_border(map, [x, y], [-1, 0])
        visit_key = "#{pos_x},#{pos_y},#{v},y+"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      elsif map.dig(y + 1, x) != v
        pos_x, pos_y = lowest(map, [x, y], [x, y + 1], [-1, 0])
        visit_key = "#{pos_x},#{pos_y},#{v},y+"

        if !sides_considered.include?(visit_key)
          sides_considered.add(visit_key)
          sides[v] = (sides[v] || 0) + 1
        end
      end
    end
  end
end

sides = {}

count_sides(map, sides)

puts (areas.keys.map { |key| areas[key] * sides[key] }).sum
