#!/usr/bin/env ruby
require 'optparse'
require 'date'

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

# 1桁の数字と2桁の数字の位置揃えのためのパディングを行う
def format_two_digits(num)
  buffer = ' ' * (2 - num.to_s.length.to_i)
  buffer + num.to_s
end

GAP = ' '
DAY_PADDING = ' ' * 2

if ENV['LANG'] == 'ja_JP.UTF-8'
  HEADER = "#{(DAY_PADDING + GAP) * 2}#{format_two_digits(first_date.month)}月 #{first_date.year}"
else
  MONTHS = [ 'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December']
  MONTH_EN = MONTHS[first_date.month - 1]
  OVERALL_WIDTH = ((DAY_PADDING * 7) + (GAP * 6)).length
  HEADER = "#{' ' * ((OVERALL_WIDTH - MONTH_EN.length - YEAR.to_s.length) / 2)}#{MONTH_EN} #{first_date.year}"
end


last_date = (first_date >> 1) -1
current_date = first_date.clone
# カレンダーの出力
# 出力する 月 と 年を表示
print HEADER
puts
# 曜日を出力
print(['日','月','火','水','木','金','土'].join(GAP))
puts

# 最初の日付が日曜日以外の時
if first_date.cwday != 7
  # 日曜日までセットバック
  current_date -= first_date.cwday
end
while (current_date <=> last_date) != 0

  unless current_date.month == MONTH
    print(DAY_PADDING + GAP)
    current_date += 1
    next
  end

  if current_date.saturday?
    puts format_two_digits(current_date.day)
  else
    print format_two_digits(current_date.day)
    print GAP
  end

  current_date += 1
end

puts
