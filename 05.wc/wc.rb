#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
OPTIONS = ARGV.getopts('l', 'w', 'c')
METHODS = {
  l: { count: :count_newlines, align: :rjust, total: :sum },
  w: { count: :count_words, align: :rjust, total: :sum },
  c: { count: :count_bytes, align: :rjust, total: :sum }
}.freeze

def main
  ARGV.any? ? display_file_counts : display_stdin_counts
end

def display_stdin_counts
  puts requested_count($stdin.read).values.join(' ')
end

def display_file_counts
  file_counts = list_file_counts
  if file_counts.length > 1
    total_count = total_count(file_counts)
    file_counts.push(total_count)
  end
  column_widths = column_widths(file_counts)
  file_counts.each do |file_count|
    puts format_count(file_count, column_widths)
  end
end

def requested_options
  if !any_options
    %i[l w c]
  else
    [
      OPTIONS['l'] ? :l : nil,
      OPTIONS['w'] ? :w : nil,
      OPTIONS['c'] ? :c : nil
    ].compact
  end
end

def any_options
  OPTIONS.any? { |_, value| value }
end

def requested_count(content)
  requested_options.map do |option|
    [option, send(METHODS[option][:count], content)]
  end.to_h
end

def list_file_counts
  ARGV.map do |file_name|
    requested_count(File.read(file_name)).merge({ file_name: })
  end
end

def count_newlines(content)
  content.lines.to_a.length
end

def count_words(content)
  content.split.length
end

def count_bytes(content)
  content.bytesize
end

def total_count(file_counts)
  requested_options.map do |option|
    [option, file_counts.sum { |file_count| file_count[option] }]
  end.to_h.merge({ file_name: 'total' })
end

def column_widths(file_counts)
  requested_options.map do |option|
    [option, file_counts.map { |file_count| file_count[option].to_s.length }.max]
  end.to_h
end

def format_count(file_count, column_widths)
  formatted_options = requested_options.map do |option|
    [option, file_count[option].to_s.send(METHODS[option][:align], column_widths[option])]
  end.to_h
  file_count.merge(formatted_options).values.join(' ')
end

main
