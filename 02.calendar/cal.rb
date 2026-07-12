#!/usr/bin/env ruby
require 'optparse'
require 'date'

options = ARGV.getopts('y:', 'm:')
YEAR = options['y'] ? options['y'] : Date.today.year
MONTH = options['m'] ? options['m'] : Date.today.month
p YEAR
p MONTH
