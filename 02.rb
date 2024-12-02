input = File.read('02.input').split("\n").map(&:strip)

# problem 1

def increasing(levels)
  i = 1

  while i < levels.size
    a = levels[i - 1]
    b = levels[i]

    diff = b - a

    return false if diff < 1 || diff > 3

    i += 1
  end

  true
end

def is_safe(levels)
  increasing(levels) || increasing(levels.reverse)
end

safe = 0

input.each do |line|
  levels = line.split(' ')
  levels = levels.map(&:to_i)

  if is_safe(levels)
    safe += 1
  end
end

puts safe

# problem 2

def is_safe2(levels)
  levels.each.with_index do |v, idx|
    new_levels = levels[0...idx] + levels[(idx + 1)...levels.size]

    return true if is_safe(new_levels)
  end

  false
end

safe = 0

input.each do |line|
  levels = line.split(' ')
  levels = levels.map(&:to_i)

  if is_safe2(levels)
    safe += 1
  end
end

puts safe
