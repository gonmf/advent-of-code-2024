input = File.read('04.input').split("\n").map(&:strip)

# problem 1

def match_xmas(word)
  word = (word.filter { |c| c }).join

  word == 'XMAS' || word == 'SAMX'
end

chars = input.map { |l| l.split('') }

total = 0

chars.each.with_index do |line, y|
  line.each.with_index do |c, x|
    word = [c, chars.dig(y, x + 1), chars.dig(y, x + 2), chars.dig(y, x + 3)]
    if match_xmas(word)
      total += 1
    end

    word = [c, chars.dig(y + 1, x), chars.dig(y + 2, x), chars.dig(y + 3, x)]
    if match_xmas(word)
      total += 1
    end

    word = [c, chars.dig(y + 1, x + 1), chars.dig(y + 2, x + 2), chars.dig(y + 3, x + 3)]
    if match_xmas(word)
      total += 1
    end

    word = [c, chars.dig(y + 1, x - 1), chars.dig(y + 2, x - 2), chars.dig(y + 3, x - 3)]
    if x > 2 && match_xmas(word)
      total += 1
    end
  end
end

p total

# problem 2

def match_mas(word)
  word = (word.filter { |c| c }).join

  word == 'MAS' || word == 'SAM'
end

total = 0
mases_diagonal = chars.map { |l| l.map { 0 } }

chars.each.with_index do |line, y|
  line.each.with_index do |c, x|
    word = [c, chars.dig(y + 1, x + 1), chars.dig(y + 2, x + 2)]
    if match_mas(word)
      mases_diagonal[y + 1][x + 1] += 1
      total += 1 if mases_diagonal[y + 1][x + 1] == 2
    end

    word = [c, chars.dig(y + 1, x - 1), chars.dig(y + 2, x - 2)]
    if x > 1 && match_mas(word)
      mases_diagonal[y + 1][x - 1] += 1
      total += 1 if mases_diagonal[y + 1][x - 1] == 2
    end
  end
end

p total
