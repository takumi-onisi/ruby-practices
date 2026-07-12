RANGE = 1..20
RANGE.each do |num| 
  # 特定の倍数の時は出力内容を変える
  # 出力結果が判定の順番によって変化しないように条件で排他性を担保する
  case
    when num % 3 == 0 && num % 5 != 0
      puts 'Fizz'
    when num % 3 != 0 && num % 5 == 0
      puts 'Buzz'
    when num % 3 == 0 && num % 5 == 0
      puts 'FizzBuzz'
    else
      puts num
  end
end
