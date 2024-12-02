input = File.read('01.input').split("\n").map(&:strip)

# problem 1

left_list = []
right_list = []

input.each do |line|
  values = line.split('   ')
  if values.size == 2
    left_list.push(values[0].to_i)
    right_list.push(values[1].to_i)
  end
end

left_list.sort!
right_list.sort!

i = 0
total_distance = 0

while i < left_list.size
  distance = (left_list[i] - right_list[i]).abs

  total_distance += distance

  i += 1
end

puts total_distance

# problem 2

i = 0
total_similarity = 0

while i < left_list.size
  similarity = left_list[i] * (right_list.count { |v| left_list[i] === v })

  total_similarity += similarity

  i += 1
end

puts total_similarity
