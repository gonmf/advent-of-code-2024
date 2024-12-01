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

# numbers = [
#   ['one', 1],
#   ['two', 2],
#   ['three', 3],
#   ['four', 4],
#   ['five', 5],
#   ['six', 6],
#   ['seven', 7],
#   ['eight', 8],
#   ['nine', 9]
# ]

# cal_sum = 0

# input.each do |line|
#   nums = []

#   line.chars.each.with_index do |c, idx|
#     if c == '0' || c.to_i > 0
#       nums.push(c.to_i)
#       next
#     end

#     token = numbers.find { |tok| line[idx..-1].start_with?(tok[0]) }
#     if token
#       nums.push(token[1].to_i)
#     end
#   end

#   cal = nums.first * 10 + nums.last

#   cal_sum += cal
# end

# puts cal_sum
