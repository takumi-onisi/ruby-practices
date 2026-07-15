#!/usr/bin/env ruby
require 'optparse'
require 'date'

class Calendar
  GAP = ' '
  DAY_PADDING = ' ' * 2
  OVERALL_WIDTH = ((DAY_PADDING * 7) + (GAP * 6)).length
  JAPANESE_WEEKDAYS = ['日','月','火','水','木','金','土']

  def initialize(year, month)
    @first_date = Date.new(year, month, 1)
  end

  # 1桁の数字と2桁の数字の位置揃えのためのパディングを行う
  def format_two_digits(num)
    num.to_s.rjust(2)
  end

  # カレンダーの月を返す
  def month_to_show()
    "#{format_two_digits(@first_date.month)}月"
  end

  # カレンダーのヘッダーを返す
  def header_contents()
    "#{(DAY_PADDING + GAP) * 2}#{month_to_show} #{@first_date.year}"
  end

  # カレンダーの曜日の行を返す
  def weekdays_row()
    JAPANESE_WEEKDAYS.join(GAP)
  end

  # カレンダーのヘッダーを出力する
  def print_header()
    print header_contents
  end

  # カレンダーの曜日の行を出力する
  def print_weekdays()
    print weekdays_row
  end

  # カレンダーの各日にちを出力する
  def print_dates
    last_date = (@first_date >> 1) -1
    current_date = @first_date.clone

    # 最初の日付が日曜日以外の時
    if @first_date.cwday != 7
      # 日曜日までセットバック
      current_date -= @first_date.cwday
    end

    # 最終日を超えるまで繰り返す
    while (current_date <=> last_date) < 1

      unless current_date.month == @first_date.month
        # 位置調整用スペーサーのみを出力して日を進める
        print(DAY_PADDING + GAP)
        current_date += 1
        next
      end
      if current_date.saturday?
        # 土曜日の時は折り返す
        puts format_two_digits(current_date.day)
      else
        print format_two_digits(current_date.day)
        print GAP
      end

      # 日を進める
      current_date += 1
    end
  end

end


# カレンダーで表示させる 年 と 月 を初期化
options = ARGV.getopts('y:', 'm:')
# 指定がない場合は今日の 年 と 月を使用する
year = options['y'] ? options['y'].to_i : Date.today.year
month = options['m'] ? options['m'].to_i : Date.today.month

# カレンダーインスタンスを生成
begin
  calendar = Calendar.new(year, month)
rescue
  puts 'エラー : カレンダーの生成に失敗しました'
  puts '-yと-mのオプションを正しく渡しているか確認してください'
  exit
end

# カレンダーの出力
# 出力する 月 と 年を表示
calendar.print_header
puts
# 曜日を出力
calendar.print_weekdays
puts
# カレンダーの各日付を表示
calendar.print_dates
puts
