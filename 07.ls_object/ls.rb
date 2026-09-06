#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
OUTPUT_COL_COUNT = 3

def main
  opt = OptionParser.new
  command_options = []
  opt.on('-a') { command_options.push :a }
  opt.parse(ARGV)
  file_names = Dir.children('.')
  if command_options.include?(:a)
    file_names.push('.')
  else
    file_names = file_names.reject { |f| f[0] == '.' }
  end
  file_names = file_names.sort
  max_length = file_names.map(&:length).max
  print_vertical_columns(file_names, OUTPUT_COL_COUNT) do |file_name|
    file_name.ljust(max_length)
  end
end

def print_vertical_columns(file_names, col_count)
  row_count = (file_names.length / col_count.to_f).ceil
  row_count.times.each do |row|
    col_count.times.each do |col|
      elem = file_names[row + col * row_count]
      print yield(elem) if elem
      print ' '
    end
    puts
  end
end

main
