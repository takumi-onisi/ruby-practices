RANGE = 1..20
RANGE.each do |num|
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
