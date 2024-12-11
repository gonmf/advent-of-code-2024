input = File.read('11.input').split("\n").map(&:strip)

# problem 1

stones = input[0].split(' ').map(&:to_i)

def count_stones(stone, left, memo)
  return 1 if left == 0

  memo["#{stone},#{left}"] ||= begin
    if stone == 0
      count_stones(1, left - 1, memo)
    elsif (stone.to_s.size % 2) == 0
      a = stone.to_s[0...(stone.to_s.size / 2)].to_i
      b = stone.to_s[(stone.to_s.size / 2)..-1].to_i

      count_stones(a, left - 1, memo) + count_stones(b, left - 1, memo)
    else
      count_stones(stone * 2024, left - 1, memo)
    end
  end
end

memo = {}

puts (stones.map { |s| count_stones(s, 25, memo) }).sum

# problem 2

puts (stones.map { |s| count_stones(s, 75, memo) }).sum
