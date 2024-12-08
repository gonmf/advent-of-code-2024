input = File.read('08.input').split("\n").map(&:strip)

# problem 1

antennas = []
antinodes = []
width = input[0].size
height = input.size

input.each.with_index do |line, y|
  line.chars.each.with_index do |c, x|
    next if c == '.'

    antennas.push([c, x, y])
  end
end

antennas.each.with_index do |ant1, ant1_i|
  antennas.each.with_index do |ant2, ant2_i|
    next if ant1_i <= ant2_i

    v1, x1, y1 = ant1
    v2, x2, y2 = ant2
    next if v1 != v2

    diff_x = x1 - x2
    diff_y = y1 - y2

    anti_x = x1 + diff_x
    anti_y = y1 + diff_y
    if anti_x >= 0 && anti_y >= 0 && anti_x < width && anti_y < height
      antinodes.push([anti_x, anti_y]) unless antinodes.include?([anti_x, anti_y])
    end

    anti_x = x2 - diff_x
    anti_y = y2 - diff_y
    if anti_x >= 0 && anti_y >= 0 && anti_x < width && anti_y < height
      antinodes.push([anti_x, anti_y]) unless antinodes.include?([anti_x, anti_y])
    end
  end
end

p antinodes.size

# problem 2

antinodes = []

antennas.each.with_index do |ant1, ant1_i|
  antennas.each.with_index do |ant2, ant2_i|
    next if ant1_i <= ant2_i

    v1, x1, y1 = ant1
    v2, x2, y2 = ant2
    next if v1 != v2

    antinodes.push([x1, y1]) unless antinodes.include?([x1, y1])

    diff_x = x1 - x2
    diff_y = y1 - y2
    anti_x = x1
    anti_y = y1

    while true
      anti_x = anti_x - diff_x
      anti_y = anti_y - diff_y

      break if anti_x < 0 || anti_y < 0 || anti_x >= width || anti_y >= height

      antinodes.push([anti_x, anti_y]) unless antinodes.include?([anti_x, anti_y])
    end

    anti_x = x1
    anti_y = y1

    while true
      anti_x = anti_x + diff_x
      anti_y = anti_y + diff_y

      break if anti_x < 0 || anti_y < 0 || anti_x >= width || anti_y >= height

      antinodes.push([anti_x, anti_y]) unless antinodes.include?([anti_x, anti_y])
    end
  end
end

p antinodes.size
