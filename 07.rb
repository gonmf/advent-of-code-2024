input = File.read('07.input').split("\n").map(&:strip)

# problem 1

def parse_equation(line)
  left, right = line.split(': ')

  [left.to_i, right.split(' ').map { |v| v.to_i }]
end

def is_valid(curr, goal, args, args_i)
  return false if curr > goal
  return curr == goal if args_i == args.size

  is_valid(curr + args[args_i], goal, args, args_i + 1) || is_valid(curr * args[args_i], goal, args, args_i + 1)
end

total = 0

input.each do |line|
  goal, args = parse_equation(line)

  if is_valid(args[0], goal, args, 1)
    total += goal
  end
end

p total

# problem 2

def is_valid(curr, goal, args, args_i)
  return false if curr > goal
  return curr == goal if args_i == args.size

  is_valid(curr + args[args_i], goal, args, args_i + 1) || is_valid(curr * args[args_i], goal, args, args_i + 1) || is_valid((curr.to_s + args[args_i].to_s).to_i, goal, args, args_i + 1)
end

total = 0

input.each do |line|
  goal, args = parse_equation(line)

  if is_valid(args[0], goal, args, 1)
    total += goal
  end
end

p total
