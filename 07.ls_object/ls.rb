#!/usr/bin/env ruby
# frozen_string_literal: true

output_col_count = 3

def print_vertical_columns(array, col_count, formatter)
  row_count = (array.length / col_count.to_f).ceil
  (0...row_count).each do |row|
    (0...col_count).each do |col|
      elem = array[row + col * row_count]
      print formatter.call(elem) if elem
      print ' '
    end
    puts
  end
end

def format_file_name(name, length)
  name.ljust(length)
end

files = Dir.children('.').sort
files = files.reject { |f| f[0] == '.' }

max_length = files.max do |a, b|
  a.length <=> b.length
end.length
formatter = proc { |name, length = max_length| format_file_name(name, length) }

print_vertical_columns(files, output_col_count, formatter)
