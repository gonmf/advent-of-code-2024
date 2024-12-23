require 'set'

input = File.read('23.input').split("\n").map(&:strip)

# problem 1

conns = Set.new
pcs = []

input.each do |line|
  conn = line.split('-').sort
  a, b = conn

  pcs.push(a) unless pcs.include?(a)
  pcs.push(b) unless pcs.include?(b)

  conns.add(conn) unless conns.include?(conn)
end

pcs = pcs.sort

total = 0

conns.to_a.each do |conn|
  a, b = conn

  pcs.each do |c|

    if a[0] == 't' || b[0] == 't' || c[0] == 't'
      if conns.include?([a, c]) && conns.include?([b, c])
        total += 1
      end
    end
  end
end

puts total

# problem 2

graph_nodes = []

conns.to_a.uniq.each do |conn|
  a, b = conn

  graph_nodes.push({ v: a, conns: [] }) unless graph_nodes.any? { |g| g[:v] == a }
  graph_nodes.push({ v: b, conns: [] }) unless graph_nodes.any? { |g| g[:v] == b }

  node_a = graph_nodes.find { |g| g[:v] == a }
  node_b = graph_nodes.find { |g| g[:v] == b }

  node_a[:conns].push(node_b)
  node_b[:conns].push(node_a)
end

@best_members = []
@already_searched = Set.new

def search(members)
  to_search = [members]

  while to_search.size > 0
    members = to_search.pop

    key = members.map { |n| n[:v] }.sort.join(',')
    next if @already_searched.include?(key)

    @already_searched.add(key)

    members_in_common = nil

    members.each do |node|
      if members_in_common.nil?
        members_in_common = node[:conns]
      else
        members_in_common = members_in_common & node[:conns]
      end
    end

    members_in_common.each do |m|
      to_search.push(members + [m])
    end

    if @best_members.size < members.size
      @best_members = members
    end
  end
end

graph_nodes.each do |node|
  search([node])
end

puts @best_members.map { |n| n[:v] }.sort.join(',')
