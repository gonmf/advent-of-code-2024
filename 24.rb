input = File.read('24.input').split("\n").map(&:strip)

# problem 1

wires = {}
gates = []

input.each do |line|
  if line.include?(': ')
    name, val = line.split(': ')
    val = val.to_i

    new_wire = {
      name: name,
      val: val
    }

    wires[name] = new_wire
    next
  end

  if line.include?(' -> ')
    in1, oper, in2, a, out = line.split(' ')

    wires[in1] = { name: in1, val: nil } unless wires[in1]
    wires[in2] = { name: in2, val: nil } unless wires[in2]
    wires[out] = { name: out, val: nil } unless wires[out]

    gates.push({
      inputs: [wires[in1], wires[in2]],
      output: wires[out],
      oper: oper
    })
  end
end

while true
  any_updated = false

  gates.each do |gate|
    next unless gate[:output][:val].nil?

    in1, in2 = gate[:inputs]
    next if in1[:val].nil? || in2[:val].nil?

    if gate[:oper] == 'AND'
      gate[:output][:val] = in1[:val] & in2[:val]
    elsif gate[:oper] == 'OR'
      gate[:output][:val] = in1[:val] | in2[:val]
    else
      gate[:output][:val] = (in1[:val] ^ in2[:val]) & 1
    end

    any_updated = true
  end

  break unless any_updated
end

puts wires.values.select { |w| w[:name][0] == 'z' }.sort_by { |w| w[:name] }.reverse.map { |w| w[:val].to_s }.join.to_i(2)

# problem 2

# The code bellow will detect the first bit position where the addition fails. Then that bit's adder just need to be locally,
# manually, fixed to be in the same format as the others, because we have 4 gates swapped and exactly also 4 bad output bits.

wires = {}
gates = []

input.each do |line|
  if line.include?(': ')
    name, val = line.split(': ')
    val = val.to_i

    new_wire = {
      name: name,
      val: val
    }

    wires[name] = new_wire
    next
  end

  if line.include?(' -> ')
    in1, oper, in2, a, out = line.split(' ')

    wires[in1] = { name: in1 } unless wires[in1]
    wires[in2] = { name: in2 } unless wires[in2]
    wires[out] = { name: out } unless wires[out]

    gate = {
      inputs: [wires[in1], wires[in2]],
      output: wires[out],
      oper: oper
    }

    wires[out][:gate] = gate

    gates.push(gate)
  end
end

wires_arr = wires.values

def settle_wire(wire)
  return unless wire[:val].nil?

  gate = wire[:gate]
  return unless gate

  in1, in2 = gate[:inputs]

  wire[:val] = 0

  settle_wire(in1)
  return if in1[:val].nil?
  settle_wire(in2)
  return if in2[:val].nil?

  if gate[:oper] == 'AND'
    wire[:val] = in1[:val] & in2[:val]
  elsif gate[:oper] == 'OR'
    wire[:val] = in1[:val] | in2[:val]
  else
    wire[:val] = (in1[:val] ^ in2[:val]) & 1
  end
end

def set_signals(x, y, wires_arr)
  x_bin = x.to_s(2).chars.reverse.map(&:to_i)
  y_bin = y.to_s(2).chars.reverse.map(&:to_i)

  wires_arr.each do |wire|
    if wire[:name][0] == 'x'
      idx = wire[:name].slice(1, 2).to_i
      # puts "#{wire[:name]} - #{idx}"
      wire[:val] = x_bin[idx].to_i
    elsif wire[:name][0] == 'y'
      idx = wire[:name].slice(1, 2).to_i
      # puts "#{wire[:name]} - #{idx}"
      wire[:val] = y_bin[idx].to_i
    else
      wire[:val] = nil
    end
  end
end

def print_dependency_tree(wire, offset = 0)
  return if offset > 3

  gate = wire[:gate]
  puts "#{"|\t" * offset}#{wire[:name]}#{gate ? " (#{gate[:oper]})": ''}"

  return unless gate

  in1, in2 = gate[:inputs]

  if in2[:gate] && in2[:gate][:oper] == 'XOR'
    print_dependency_tree(in2, offset + 1)
    print_dependency_tree(in1, offset + 1)
  elsif in2[:gate] && in2[:gate][:oper] == 'AND'
    print_dependency_tree(in2, offset + 1)
    print_dependency_tree(in1, offset + 1)
  else
    print_dependency_tree(in1, offset + 1)
    print_dependency_tree(in2, offset + 1)
  end
end

goal_wires = wires_arr.select { |w| w[:name][0] == 'z' }.sort_by { |w| w[:name] }

goal_wires.each.with_index do |wire, wire_i|
  print_dependency_tree(wire)

  failed_at = nil
  (0..1000).each do
    x = (rand * (2 << 44)).truncate
    y = (rand * (2 << 44)).truncate
    expected = x + y
    expected_bin = expected.to_s(2).chars.reverse.map(&:to_i)

    set_signals(x, y, wires_arr)

    goal_wires.each.with_index do |wire, idx|
      settle_wire(wire)

      if wire[:val] != expected_bin[idx].to_i
        failed_at = wire[:name]
        break
      end
    end

    break unless failed_at.nil?
  end

  puts failed_at ? "FAIL @ #{failed_at}" : 'OK'

  gets
end
