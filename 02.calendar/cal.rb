#!/usr/bin/env ruby
require 'optparse'
require 'date'

options = ARGV.getopts('y:', 'm:')
year = options['y'] ? options['y'].to_i : Date.today.year
month = options['m'] ? options['m'].to_i : Date.today.month

begin
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
rescue
  puts 'エラー : カレンダーの生成に失敗しました'
  puts '-yと-mのオプションを正しく渡しているか確認してください'
  exit
end

puts "#{' ' * 6}#{first_date.month.to_s.rjust(2)}月 #{first_date.year}"
puts '日 月 火 水 木 金 土'

print ' ' * 3 * first_date.wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2)

  break if date == last_date

  if date.saturday?
    puts
  else
    print ' '
  end
end

puts
