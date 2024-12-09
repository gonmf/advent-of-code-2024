input = File.read('09.input').split("\n").map(&:strip)

# problem 1

cs = input[0].chars

files = []
blocks = []

cs.each.with_index do |val, i|
  val = val.to_i

  if (i % 2) == 1
    blocks = blocks + (0...val).to_a.map { nil }
    next
  end

  id = files.size
  files.push({ id: id, size: val })

  blocks = blocks + (0...val).to_a.map { id }
end

open_i = 0
end_i = blocks.size - 1

while end_i > open_i
  if blocks[open_i]
    open_i += 1
    next
  end

  while end_i > open_i
    if blocks[end_i]
      blocks[open_i] = blocks[end_i]
      blocks[end_i] = nil
      end_i -= 1
      break
    else
      end_i -= 1
    end
  end

  open_i += 1
end

total = 0

blocks.each.with_index do |val, i|
  break if val.nil?

  total += i * val
end

puts total

# problem 2

files = []
files_count = 0

cs.each.with_index do |val, i|
  val = val.to_i

  if (i % 2) == 1
    files.push({ id: nil, size: val })
    next
  end

  files.push({ id: files_count, size: val })

  files_count += 1
end

end_i = files.size - 1

while end_i > 0
  if files[end_i][:id].nil?
    end_i -= 1
    next
  end

  open_i = 0

  while open_i < end_i
    if files[open_i][:id].nil? && files[open_i][:size] >= files[end_i][:size]
      left_over = files[open_i][:size] - files[end_i][:size]
      files[open_i][:size] = files[end_i][:size]
      files[open_i][:id] = files[end_i][:id]
      files[end_i][:id] = nil
      last_open_i = open_i + 1

      if left_over > 0
        files.insert(open_i + 1, { id: nil, size: left_over })
        end_i += 1
      end

      break
    end

    open_i += 1
  end

  end_i -= 1
end

blocks = files.flat_map { |file| (0...file[:size]).to_a.map { file[:id].nil? ? nil : file[:id] } }

total = 0

blocks.each.with_index do |val, i|
  total += i * val unless val.nil?
end

puts total
