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
  puts requested_counts($stdin.readlines).values.join(' ')
end

def display_file_counts
  counts_lists = list_file_counts
  if counts_lists.length > 1
    total_counts = total_counts(counts_lists)
    counts_lists.push(total_counts)
  end
  column_widths = column_widths(counts_lists)
  counts_lists.map do |counts|
    puts format_counts(counts, column_widths)
  end
end

def requested_options
  [
    !any_options || OPTIONS['l'] ? :l : nil,
    !any_options || OPTIONS['w'] ? :w : nil,
    !any_options || OPTIONS['c'] ? :c : nil
  ].compact
end

def any_options
  OPTIONS.any? { |_, value| value }
end

def requested_counts(input_lines)
  requested_options.map do |option|
    [option, send(METHODS[option][:count], input_lines)]
  end.to_h
end

def list_file_counts
  ARGV.map do |file_name|
    requested_counts(File.open(file_name, &:readlines)).merge({ file_name: file_name })
  end
end

def count_newlines(input_lines)
  input_lines.length
end

def count_words(input_lines)
  input_lines.join.split.length
end

def count_bytes(input_lines)
  input_lines.join.bytesize
end

def total_counts(counts_lists)
  requested_options.map do |option|
    [option, counts_lists.sum { |counts| counts[option] }]
  end.to_h.merge({ file_name: 'total' })
end

def column_widths(counts_lists)
  requested_options.map do |option|
    [option, counts_lists.map { |counts| counts[option].to_s.length }.max]
  end.to_h
end

def format_counts(counts, column_widths)
  formatted_options = requested_options.map do |option|
    [option, counts[option].to_s.send(METHODS[option][:align], column_widths[option])]
  end.to_h
  counts.merge(formatted_options).values.join(' ')
end

main
