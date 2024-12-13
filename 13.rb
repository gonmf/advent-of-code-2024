require 'set'

input = File.read('13.input').split("\n").map(&:strip)

# problem 1

goals = []

input.each.with_index do |line, i|
  next unless line.start_with?('Prize: ')

  x, y = input[i - 2].split(': ')[1].split(', ')
  a_x = x.split('+')[1].to_i
  a_y = y.split('+')[1].to_i

  x, y = input[i - 1].split(': ')[1].split(', ')
  b_x = x.split('+')[1].to_i
  b_y = y.split('+')[1].to_i


  x, y = line.split(': ')[1].split(', ')
  goal_x = x.split('=')[1].to_i
  goal_y = y.split('=')[1].to_i

  goals.push([
    a_x,
    a_y,
    b_x,
    b_y,
    goal_x,
    goal_y,
  ])
end

def solve(goals)
  total = 0

  goals.each do |goal|
    a_x, a_y, b_x, b_y, goal_x, goal_y = goal

    a_presses = (goal_x * b_y - goal_y * b_x) / (a_x * b_y - a_y * b_x)
    b_presses = (a_x * goal_y - a_y * goal_x) / (a_x * b_y - a_y * b_x)

    if (a_presses * a_x + b_presses * b_x == goal_x) && (a_presses * a_y + b_presses * b_y == goal_y)
      cost = a_presses * 3 + b_presses
      total += cost
    end
  end

  total
end

puts solve(goals)

# problem 2

goals.each do |goal|
  goal[4] += 10000000000000
  goal[5] += 10000000000000
end

puts solve(goals)
