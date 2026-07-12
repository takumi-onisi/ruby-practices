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

puts first_day
