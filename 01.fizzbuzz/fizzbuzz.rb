RANGE = 1..20
RANGE.each do |num|
  # 特定の倍数の時は出力内容を変える
  if num % 3 == 0 && num % 5 == 0 then
    puts 'FizzBuzz'
  elsif num % 3 == 0 then
    puts 'Fizz'
  elsif num % 5 == 0 then
    puts 'Buzz'
  else
    puts num
  end
end
