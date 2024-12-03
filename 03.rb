input = File.read('03.input').split("\n").map(&:strip)

# problem 1

def eval(line)
  seq = nil
  nr1 = []
  nr2 = []
  total = 0

  line.chars.each.with_index do |c, idx|
    if seq.nil?
      if c == 'm'
        seq = 'm'
      end

      next
    end

    if seq == 'm'
      if c == 'u'
        seq = 'u'
      else
        seq = nil
      end

      next
    end

    if seq == 'u'
      if c == 'l'
        seq = 'l'
      else
        seq = nil
      end

      next
    end

    if seq == 'l'
      if c == '('
        seq = '('
        nr1 = []
      else
        seq = nil
      end

      next
    end

    if seq == '('
      if c >= '0' && c <= '9'
        if nr1.size < 3
          nr1.push(c)
        else
          seq = nil
        end
      elsif c == ','
        if nr1.size > 0
          seq = ','
          nr2 = []
        else
          seq = nil
        end
      else
        seq = nil
      end

      next
    end

    if seq == ','
      if c >= '0' && c <= '9'
        if nr2.size < 3
          nr2.push(c)
        else
          seq = nil
        end
      elsif c == ')'
        if nr2.size > 0
          seq = nil
          total += nr1.join.to_i * nr2.join.to_i
        else
          seq = nil
        end
      else
        seq = nil
      end

      next
    end
  end

  total
end

line = input.join

p eval(line)

# problem 2

line = input.join
total = 0

line.split("don't()").each.with_index do |subline, idx|
  if idx == 0
    total += eval(subline)
  else
    subsubline = subline.split('do()')[1..-1].join('do()')
    total += eval(subsubline)
  end
end

p total
