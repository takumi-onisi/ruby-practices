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

start_date = first_date.cwday == 7 ? first_date.clone : first_date.clone - first_date.cwday

(start_date..last_date).each do |date|
  if date.month != first_date.month
    print(' ' * 3)
    next
  end
  if date.saturday?
    print date.day.to_s.rjust(2)
    puts if date != last_date
  else
    print date.day.to_s.rjust(2)
    print ' '
  end
end

puts
