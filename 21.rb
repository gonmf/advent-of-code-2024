require 'set'

input = File.read('21.input').split("\n").map(&:strip)

# problem 1

def numpad_coord(c)
  return [0, 0] if c == '7'
  return [1, 0] if c == '8'
  return [2, 0] if c == '9'
  return [0, 1] if c == '4'
  return [1, 1] if c == '5'
  return [2, 1] if c == '6'
  return [0, 2] if c == '1'
  return [1, 2] if c == '2'
  return [2, 2] if c == '3'
  return [1, 3] if c == '0'
  [2, 3]
end

def keypad_coord(c)
  return [1, 0] if c == '^'
  return [2, 0] if c == 'A'
  return [0, 1] if c == '<'
  return [1, 1] if c == 'v'
  [2, 1]
end

@possible_paths_memo = {}

def calc_possible_paths(a, b, depth)
  @possible_paths_memo[[a, b, depth].flatten.join(',')] ||= begin
    return [['A']] if a == b

    bad_spot = depth == 0 ? [0, 3] : [0, 0]
    return [] if a == bad_spot

    a_x, a_y = a
    b_x, b_y = b

    paths = []

    if a_x < b_x
      new_path = Array.new(b_x - a_x, '>')
      calc_possible_paths([b_x, a_y], b, depth).each do |subpath|
        paths.push(new_path + subpath)
      end
    end
    if a_x > b_x
      new_path = Array.new(a_x - b_x, '<')
      calc_possible_paths([b_x, a_y], b, depth).each do |subpath|
        paths.push(new_path + subpath)
      end
    end
    if a_y < b_y
      new_path = Array.new(b_y - a_y, 'v')
      calc_possible_paths([a_x, b_y], b, depth).each do |subpath|
        paths.push(new_path + subpath)
      end
    end
    if a_y > b_y
      new_path = Array.new(a_y - b_y, '^')
      calc_possible_paths([a_x, b_y], b, depth).each do |subpath|
        paths.push(new_path + subpath)
      end
    end

    paths
  end
end

def moving_cost(goal, depth, max_depth, robots_pos)
  from = robots_pos[depth]

  min_path_presses, new_robots_pos = @moving_cost_memo[[from, goal, depth, robots_pos[depth]].flatten] ||= begin
    x0, y0 = from
    x1, y1 = goal

    possible_paths = calc_possible_paths(from, goal, depth == 0 ?  0 : 1)

    robots_pos[depth] = goal

    if depth == max_depth
      [possible_paths.map { |p| p.size }.min, goal]
    else
      min_path_presses = nil

      possible_paths.each do |possible_path|
        min_presses = 0

        possible_path.each do |c|
          new_goal = keypad_coord(c)

          presses_nr = moving_cost(new_goal, depth + 1, max_depth, robots_pos)
          min_presses += presses_nr
        end

        min_path_presses = min_presses if min_path_presses.nil? || min_path_presses > min_presses
      end

      [min_path_presses, goal]
    end
  end

  robots_pos[depth] = new_robots_pos
  min_path_presses
end

robots_pos = [[2, 3], [2, 0], [2, 0]]
@moving_cost_memo = {}
total_complexity = 0

input.each do |code|
  total_presses_nr = 0

  code.chars.each do |c|
    goal = numpad_coord(c)

    presses_nr = moving_cost(goal, 0, 2, robots_pos)
    total_presses_nr += presses_nr
  end

  complexity = total_presses_nr * code.slice(0, code.size - 1).to_i
  total_complexity += complexity
end

puts total_complexity

# problem 2

robots_pos = [[2, 3], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0]]
@moving_cost_memo = {}
total_complexity = 0

input.each do |code|
  total_presses_nr = 0

  code.chars.each do |c|
    goal = numpad_coord(c)

    presses_nr = moving_cost(goal, 0, 25, robots_pos)
    total_presses_nr += presses_nr
  end

  complexity = total_presses_nr * code.slice(0, code.size - 1).to_i
  total_complexity += complexity
end

puts total_complexity
