#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0
frames.each_cons(2) do |cons_frames|
  current_points = cons_frames[0]
  next_points = cons_frames[1]
  if current_points[0] == 10
    point += current_points.sum + next_points.sum
    next
  end
  if current_points.sum == 10
    point += current_points.sum + next_points[0]
    next
  end
  point += current_points.sum
end
p point
