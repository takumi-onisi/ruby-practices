#!/usr/bin/env ruby
require 'optparse'
require 'date'

# 1桁の数字と2桁の数字の位置揃えのためのパディングを行う
def format_two_digits(num)
  buffer = ' ' * (2 - num.to_s.length.to_i)
  buffer + num.to_s
end

# カレンダーで表示させる 年 と 月 を初期化
options = ARGV.getopts('y:', 'm:')
# 指定がない場合は今日の 年 と 月を使用する
YEAR = options['y'] ? options['y'].to_i : Date.today.year
MONTH = options['m'] ? options['m'].to_i : Date.today.month

# カレンダーで表示させるDateインスタンスを生成
begin
  first_date = Date.new(YEAR, MONTH, 1)
rescue
  puts 'エラー : カレンダーの生成に失敗しました'
  puts '-yと-mのオプションを正しく渡しているか確認してください'
end


last_date = (first_date >> 1) -1
current_date = first_date.clone
gap = ' '
day_padding = ' ' * 2
# カレンダーの出力
# 出力する 月 と 年を表示
print "#{(day_padding + gap) * 2}#{format_two_digits(first_date.month)}月 #{first_date.year}"
puts
# 曜日を出力
print(['日','月','火','水','木','金','土'].join(gap))
puts

# 最初の日付を日曜日までセットバック
current_date -= first_date.cwday
while current_date.day != last_date.day

  unless current_date.month == MONTH
    print(day_padding + gap)
    current_date += 1
    next
  end

  if current_date.saturday?
    puts format_two_digits(current_date.day)
  else
    print format_two_digits(current_date.day)
    print gap
  end

  current_date += 1
end

puts
