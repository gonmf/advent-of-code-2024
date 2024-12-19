require 'set'

input = File.read('17.input').split("\n").map(&:strip)

# problem 1

registers = [
  0,
  0,
  0,
]

prog = []

input.each do |line|
  if line.start_with?('Register A: ')
    registers[0] = line.split(': ')[1].to_i
  end
  if line.start_with?('Register B: ')
    registers[1] = line.split(': ')[1].to_i
  end
  if line.start_with?('Register C: ')
    registers[2] = line.split(': ')[1].to_i
  end

  if line.start_with?('Program: ')
    prog = line.split(': ')[1].split(',').map(&:to_i)
  end
end

def simple_program(registers, prog, goal)
  isp = 0

  outputs = []

  while !prog[isp].nil?
    opcode = prog[isp]

    if opcode == 0 # adv
      numerator = registers[0]
      combo_operand = prog[isp + 1] < 4 ? prog[isp + 1] : registers[prog[isp + 1] - 4]
      registers[0] = numerator >> combo_operand

      isp += 2
      next
    end

    if opcode == 1 # bxl
      registers[1] = registers[1] ^ prog[isp + 1]

      isp += 2
      next
    end

    if opcode == 2 # bst
      combo_operand = prog[isp + 1] < 4 ? prog[isp + 1] : registers[prog[isp + 1] - 4]
      registers[1] = combo_operand & 7

      isp += 2
      next
    end

    if opcode == 3 # jnz
      if registers[0] != 0
        isp = prog[isp + 1]
        next
      end

      isp += 2
      next
    end

    if opcode == 4 # bxc
      registers[1] = registers[1] ^ registers[2]

      isp += 2
      next
    end

    if opcode == 5 # out
      combo_operand = prog[isp + 1] < 4 ? prog[isp + 1] : registers[prog[isp + 1] - 4]
      val = combo_operand & 7
      if !goal.nil? && (goal[outputs.size].nil? || goal[outputs.size] != val)
        return nil
      end

      outputs.push(val)

      isp += 2
      next
    end

    if opcode == 6 # bdv
      numerator = registers[0]
      combo_operand = prog[isp + 1] < 4 ? prog[isp + 1] : registers[prog[isp + 1] - 4]
      registers[1] = numerator >> combo_operand

      isp += 2
      next
    end

    if opcode == 7 # cdv
      numerator = registers[0]
      combo_operand = prog[isp + 1] < 4 ? prog[isp + 1] : registers[prog[isp + 1] - 4]
      registers[2] = numerator >> combo_operand

      isp += 2
      next
    end
  end

  if !goal.nil?
    return outputs == goal ? outputs : nil
  end

  outputs
end

puts simple_program(registers, prog, nil).map(&:to_s).join(',')

# program 2

def disasm_program(a, output = [])
  b = a & 7
  b = b ^ 2
  c = a >> b
  b = b ^ c
  b = b ^ 3
  a = a >> 3

  output.push(b & 7)

  if a == 0
    output
  else
    disasm_program(a, output)
  end
end

def search(goal, depth, sum, solutions)
  (0..7).to_a.each do |v1|
    new_sum = (sum << 3) + v1

    result = disasm_program(new_sum)

    if result == goal.last(depth + 1)
      if result == goal
        solutions.push(new_sum)
      else
        search(goal, depth + 1, new_sum, solutions)
      end
    end
  end
end

solutions = []
search(prog, 0, 0, solutions)

puts solutions.min
