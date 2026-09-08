#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
OUTPUT_COL_COUNT = 3

def main
  opt = OptionParser.new
  command_options = []
  opt.on('-a') { command_options.push :a }
  opt.parse(ARGV)
  entry_names = list_entries(command_options)
  entry_names = entry_names.sort
  max_length = entry_names.map(&:length).max
  print_vertical_columns(entry_names, OUTPUT_COL_COUNT) do |file_name|
    file_name.ljust(max_length)
  end
end

def list_entries(command_options)
  entries = Dir.children('.')
  if command_options.include?(:a)
    entries.push('.')
  else
    entries.reject { |f| f[0] == '.' }
  end
end

def print_vertical_columns(entry_names, col_count)
  row_count = (entry_names.length / col_count.to_f).ceil
  row_count.times.each do |row|
    col_count.times.each do |col|
      entry_name = entry_names[row + col * row_count]
      print yield(entry_name) if entry_name
      print ' '
    end
    puts
  end
end

main
