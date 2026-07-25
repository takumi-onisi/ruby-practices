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

tmp_frames = shots.each_slice(2).to_a.map {|s| s.eql?([10,0]) ? [10] : s}
frames = tmp_frames.take(9).push tmp_frames[9..-1].flatten
point = 0
(0..8).each do |i|
  current_points = frames[i]
  if i < 8
    next_points = frames[i+1] + frames[i+2]
  else
    next_points = frames[i+1]
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

p point
