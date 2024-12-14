input = File.read('14.input').split("\n").map(&:strip)

# problem 1

robots = input.map do |line|
  a, b = line.split(' ')

  pos = a.split('=')[1]
  pos_x, pos_y = pos.split(',')
  pos_x = pos_x.to_i
  pos_y = pos_y.to_i

  dir = b.split('=')[1]
  dir_x, dir_y = dir.split(',')
  dir_x = dir_x.to_i
  dir_y = dir_y.to_i

  [pos_x, pos_y, dir_x, dir_y]
end

width = 101
height = 103

robots_per_quadrant = {}

robots.each do |robot|
  pos_x, pos_y, dir_x, dir_y = robot

  pos_x = (pos_x + dir_x * 100) % width
  pos_y = (pos_y + dir_y * 100) % height

  next if pos_x == width / 2 || pos_y == height / 2

  quadrant = (pos_y < height / 2 ? 2 : 0) + (pos_x < width / 2 ? 1 : 0)
  robots_per_quadrant[quadrant] ||= 0
  robots_per_quadrant[quadrant] += 1
end

vals = robots_per_quadrant.values

total = 1

vals.each do |val|
  total *= val
end

puts total

# problem 2

i = 1

while true
  filled_in = {}

  robots.each do |robot|
    pos_x, pos_y, dir_x, dir_y = robot

    robot[0] = (pos_x + dir_x) % width
    robot[1] = (pos_y + dir_y) % height

    filled_in[robot[1]] ||= {}
    filled_in[robot[1]][robot[0]] = true
  end

  found = false

  (10...(height - 30)).each do |y|
    filled = filled_in[y] || {}

    (10...(width - 30)).to_a.map do |x|
      if (0...10).all? { |offset| filled[x + offset] }
        puts i
        exit
      end
    end
  end

  i += 1
end

