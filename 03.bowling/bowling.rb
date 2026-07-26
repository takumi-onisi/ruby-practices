#!/usr/bin/env ruby
# frozen_string_literal: true

frames = Array.new(10) { [] }
i = 0
ARGV[0].split(',').each do |score|
  score = 10 if score == 'X'

  if i > 8
    frames[i] << score.to_i
    next
  end

  frames[i] << score.to_i

  i += 1 if frames[i].length == 2 || score == 10
end

point = 0
(0..8).each do |i|
  current_points = frames[i]
  next_points = if i < 8
                  frames[i + 1] + frames[i + 2]
                else
                  frames[i + 1]
                end
  if current_points[0] == 10
    point += current_points.sum + next_points.take(2).sum
    next
  end
  if current_points.sum == 10
    point += current_points.sum + next_points[0]
    next
  end
  point += current_points.sum
end
point += frames[9].sum

puts point
