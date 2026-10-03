#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
OUTPUT_COL_COUNT = 3
FILE_TYPES = {
  'file' => '-',
  'blockSpecial' => 'b',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'link' => 'l',
  'fifo' => 'p',
  'socket' => 's',
  'unknown' => '?'
}.freeze
PERMISSION_CHARS = %w[x w r].freeze

def main
  command_options, paths = parse_options
  paths.push('.') if paths.empty?
  paths.each do |target_path|
    puts "#{target_path}:" if paths.length > 1
    entries = list_entries(command_options, target_path)
    entries = sort_entries(command_options, entries)
    entries = enrich_entries(entries) if command_options.include?(:l)
    entries = align_entries(entries)
    puts "total #{entries.map { |entry| entry[:blocks].to_i }.sum / 2}" if paths.length == 1
    display_entries(command_options, entries)
    puts
  end
end

def parse_options
  command_options = []
  opt = OptionParser.new
  opt.on('-a') { command_options.push :a }
  opt.on('-r') { command_options.push :r }
  opt.on('-l') { command_options.push :l }
  [command_options, opt.parse(ARGV)]
end

def display_entries(command_options, entries)
  output_col_count = command_options.include?(:l) ? 1 : OUTPUT_COL_COUNT
  print_vertical_columns(entries, output_col_count) do |entry|
    if command_options.include?(:l)
      concat_entry_info(entry)
    else
      entry[:display_name]
    end
  end
end

def list_entries(command_options, target_path)
  entry_names = Dir.children(target_path)
  entries = entry_names.map do |entry_name|
    { display_name: entry_name, path: File.join(target_path, entry_name) }
  end
  if command_options.include?(:a)
    entries.push({ display_name: '.', path: target_path })
    entries.push({ display_name: '..', path: File.dirname(File.expand_path(target_path)) })
  else
    entries = entries.reject { |entry| entry[:display_name][0] == '.' }
  end
  entries
end

def enrich_entries(entries)
  entries.map do |entry|
    stat = File.lstat(entry[:path])
    entry.merge(
      filetype: FILE_TYPES[stat.ftype] || '?',
      permission: format_permission(stat.mode),
      nlink: stat.nlink,
      owner: stat.uid.then { |id| Etc.getpwuid(id) }.name,
      group: stat.gid.then { |id| Etc.getgrgid(id) }.name,
      size: stat.size,
      mtime: stat.mtime.then { |time| time.strftime('%b %e %H:%M') },
      link_ref: stat.symlink? ? File.basename(File.realpath(entry[:path])) : '',
      blocks: stat.blocks
    )
  end
end

def sort_entries(command_options, entries)
  sorted_entries = entries.sort_by { |entry| entry[:display_name] }
  command_options.include?(:r) ? sorted_entries.reverse : sorted_entries
end

def format_permission(mode)
  p_str = ''
  9.times do |n|
    p_str = "#{mode & 2**n == 2**n ? PERMISSION_CHARS[n % 3] : '-'}#{p_str}"
  end
  if mode & 0x200 == 0x200
    p_str[-1] = p_str[-1].eql?('x') ? 't' : 'T'
  end
  if mode & 0x400 == 0x400
    p_str[-4] = p_str[-4].eql?('x') ? 's' : 'S'
  end
  if mode & 0x800 == 0x800
    p_str[-7] = p_str[-7].eql?('x') ? 's' : 'S'
  end
  p_str
end

def align_entries(entries)
  return entries if entries.empty?

  copied_entries = entries.map(&:dup)
  max_prop_widths = calc_max_prop_widths(copied_entries)
  copied_entries.each do |copied_entry|
    max_prop_widths.each do |prop, width|
      copied_entry[prop] =
        if copied_entry[prop].is_a?(Numeric)
          copied_entry[prop].to_s.rjust(width)
        elsif copied_entry[prop].is_a?(String)
          copied_entry[prop].ljust(width)
        else
          raise ArgumentError, "unsupported type: #{copied_entry[prop].class}"
        end
    end
  end
  copied_entries
end

def calc_max_prop_widths(entries)
  prop_widths = {}
  table_headers = entries.first.keys
  table_headers.each do |prop|
    prop_widths[prop] = entries.map { |entry| entry[prop].to_s.length }.max
  end
  prop_widths
end

def concat_entry_info(entry)
  entry_info = "#{entry[:filetype]}#{entry[:permission]}"
  entry_info = "#{entry_info} #{entry[:nlink]}"
  entry_info = "#{entry_info} #{entry[:owner]}"
  entry_info = "#{entry_info} #{entry[:group]}"
  entry_info = "#{entry_info} #{entry[:size]}"
  entry_info = "#{entry_info} #{entry[:mtime]}"
  link_ref = entry[:link_ref].strip.empty? ? '' : " -> #{entry[:link_ref]}"
  "#{entry_info} #{entry[:display_name].strip}#{link_ref}"
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
