#!/usr/bin/env ruby
require 'optparse'
require 'date'

class Calendar
  GAP = ' '
  DAY_PADDING = ' ' * 2
  OVERALL_WIDTH = ((DAY_PADDING * 7) + (GAP * 6)).length
  ENGLISH_MONTHS = [ 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December']
  JAPANESE_WEEKDAYS = ['日','月','火','水','木','金','土']
  ENGLISH_WEEKDAYS = ['Su','Mo','Tu','We','Th','Fr','Sa']


  def initialize(year, month)
    @first_date = Date.new(year, month, 1)
  end

  # 1桁の数字と2桁の数字の位置揃えのためのパディングを行う
  def format_two_digits(num)
    buffer = ' ' * (2 - num.to_s.length.to_i)
    buffer + num.to_s
  end

  # カレンダーの月を返す
  def get_month_to_show(lang)
    if lang == 'ja_JP.UTF-8'
      "#{format_two_digits(@first_date.month)}月"
    else
      ENGLISH_MONTHS[@first_date.month - 1]
    end
  end

  # カレンダーのヘッダーを返す
  def get_header_contents(lang)
    if lang == 'ja_JP.UTF-8'
      month = get_month_to_show(lang)
      "#{(DAY_PADDING + GAP) * 2}#{format_two_digits(@first_date.month)}月 #{@first_date.year}"
    else
      month = get_month_to_show(lang)
      "#{' ' * ((OVERALL_WIDTH - month.length - @first_date.year.to_s.length) / 2)}#{month} #{@first_date.year}"
    end
  end

  # カレンダーの曜日の行を返す
  def get_weekdays_row(lang)
    if lang == 'ja_JP.UTF-8'
      JAPANESE_WEEKDAYS.join(GAP)
    else
      ENGLISH_WEEKDAYS.join(GAP)
    end
  end

  # カレンダーのヘッダーを出力する
  def print_header(lang)
    print (get_header_contents(lang))
  end

  # カレンダーの曜日の行を出力する
  def print_weekdays(lang)
    print get_weekdays_row(lang)
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
YEAR = options['y'] ? options['y'].to_i : Date.today.year
MONTH = options['m'] ? options['m'].to_i : Date.today.month

# カレンダーインスタンスを生成
begin
  calendar = Calendar.new(YEAR, MONTH)
rescue
  if ENV['LANG'] == 'ja_JP.UTF-8'
    puts 'エラー : カレンダーの生成に失敗しました'
    puts '-yと-mのオプションを正しく渡しているか確認してください'
  else
    puts 'Error: Failed to generate the calendar.'
    puts 'Please check that the -y and -m options are specified correctly.'
  end
  exit
end

# カレンダーの出力
# 出力する 月 と 年を表示
calendar.print_header(ENV['LANG'])
puts
# 曜日を出力
calendar.print_weekdays(ENV['LANG'])
puts
# カレンダーの各日付を表示
calendar.print_dates
puts
