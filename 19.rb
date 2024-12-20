input = File.read('19.input').split("\n").map(&:strip)

# problem 1

patterns = nil
designs = []
possible_designs = []

input.each do |line|
  if patterns.nil?
    patterns = line.split(', ')
    next
  end

  next if line.size == 0

  designs.push(line)
end

def count_the_ways(design, patterns, memo)
  memo[design] ||= begin
    total = 0

    patterns.each do |pattern|
      if design.start_with?(pattern)
        if design == pattern
          total += 1
        end

        total += count_the_ways(design.slice(pattern.size, design.size), patterns, memo)
      end
    end

    total
  end
end

total1 = 0
total2 = 0
memo = {}

designs.each do |design|
  ways = count_the_ways(design, patterns, memo)
  total1 += 1 if ways > 0
  total2 += ways
end

puts total1

# problem 2

puts total2
