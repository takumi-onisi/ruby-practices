#!/usr/bin/env ruby
# frozen_string_literal: true

OUTPUT_COL_COUNT = 3

def main
  file_names = Dir.children('.').sort
  file_names = file_names.reject { |f| f[0] == '.' }
  max_length = file_names.map(&:length).max
  print_vertical_columns(file_names, OUTPUT_COL_COUNT) do |file_name|
    file_name.ljust(max_length)
  end
end

def print_vertical_columns(array, col_count)
  row_count = (array.length / col_count.to_f).ceil
  row_count.times.each do |row|
    col_count.times.each do |col|
      elem = array[row + col * row_count]
      print yield(elem) if elem
      print ' '
    end
    puts
  end
end

main
