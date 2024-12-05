input = File.read('05.input').split("\n").map(&:strip)

# problem 1

rules = {}

def update_rule(rules, a, b)
  rules[a] ||= { lower_than: [], greater_than: [] }
  rules[b] ||= { lower_than: [], greater_than: [] }

  unless rules[a][:lower_than].include?(b)
    rules[a][:lower_than].push(b)
  end

  unless rules[b][:greater_than].include?(a)
    rules[b][:greater_than].push(a)
  end
end

rules_ended = false
updates = []
input.each do |line|
  if line == ''
    rules_ended = true
    next
  end

  if rules_ended
    updates.push(line.split(',').map(&:to_i))
  else
    a, b = line.split('|').map(&:to_i)

    update_rule(rules, a, b)
  end
end

def sort_update(rules, update)
  update.dup.each do |val|
    rule = rules[val]

    left = update.filter { |v| !rule[:lower_than].include?(v) }
    right = update.filter { |v| !rule[:greater_than].include?(v) }

    update = (left + [val] + right).uniq
  end

  update
end

total = 0

updates.each do |update|
  sorted = sort_update(rules, update)

  if update == sorted
    total += update[update.size / 2]
  end
end

p total

# problem 2

total = 0

updates.each do |update|
  sorted = sort_update(rules, update)

  if update != sorted
    total += sorted[sorted.size / 2]
  end
end

p total

