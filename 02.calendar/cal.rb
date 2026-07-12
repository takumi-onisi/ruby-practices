#!/usr/bin/env ruby
require 'optparse'
require 'date'

# カレンダーで表示させる 年 と 月 を初期化
options = ARGV.getopts('y:', 'm:')
# 指定がない場合は今日の 年 と 月を使用する
YEAR = options['y'] ? options['y'] : Date.today.year
MONTH = options['m'] ? options['m'] : Date.today.month
p YEAR
p MONTH
