require 'set'

input = File.read('22.input').split("\n").map(&:strip)

# problem 1

def next_secret(secret)
  secret = (secret ^ (secret << 6)) & 0xffffff

  secret = (secret ^ (secret >> 5))

  secret = (secret ^ (secret << 11)) & 0xffffff
end

total = 0

sequence_rewards = {}

input.each.with_index do |line, i|
  secret_nr = line.to_i

  prev_price = 0
  diff_sequence = []
  sequences_seen = Set.new

  (0...2000).each do
    secret_nr = next_secret(secret_nr)

    price = secret_nr % 10

    digit_diff = price - prev_price

    prev_price = price
    diff_sequence.push(digit_diff)

    if diff_sequence.size > 4
      diff_sequence.shift

      sequence_key = diff_sequence.join(',')

      if !sequences_seen.include?(sequence_key)
        sequences_seen.add(sequence_key)
        sequence_rewards[sequence_key] = (sequence_rewards[sequence_key] || 0) + price
      end
    end
  end

  total += secret_nr
end

# problem 1

puts total

# problem 2

puts sequence_rewards.values.max
