#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
OUTPUT_COL_COUNT = 3

def main
  command_options, paths = parse_options
  paths.push('.') if paths.empty?
  paths.each do |target_path|
    puts "#{target_path}:" if paths.length > 1
    display_entries(command_options, target_path)
    puts
  end
end

def parse_options
  command_options = []
  opt = OptionParser.new
  opt.on('-a') { command_options.push :a }
  opt.on('-r') { command_options.push :r }
  [command_options, opt.parse(ARGV)]
end

def display_entries(command_options, target_path)
  entries = list_entries(command_options, target_path)
  entries = command_options.include?(:r) ? entries.sort_by { |entry| entry[:display_name] }.reverse : entries.sort_by { |entry| entry[:display_name] }
  max_length = entries.map{|entry|entry[:display_name].length}.max
  print_vertical_columns(entries, OUTPUT_COL_COUNT) do |entry|
    entry[:display_name].ljust(max_length)
  end
end

def list_entries(command_options, target_path)
  entry_names = Dir.children(target_path)
  entries = []
  entry_names.each do |entry_name|
    entries.push({ display_name: entry_name, path: File.join(target_path, entry_name) })
  end
  if command_options.include?(:a)
    entries.push({ display_name: '.', path: target_path })
  else
    entries = entries.reject { |entry| entry[:display_name][0] == '.' }
  end
end

def print_vertical_columns(entries, col_count)
  row_count = (entries.length / col_count.to_f).ceil
  row_count.times.each do |row|
    col_count.times.each do |col|
      entry = entries[row + col * row_count]
      print yield(entry) if entry
      print ' '
    end
    puts
  end
end

main
