#!/usr/bin/env ruby
require 'optparse'

options = ARGV.getopts('y:', 'm:')
puts options['y']
puts options['m']
