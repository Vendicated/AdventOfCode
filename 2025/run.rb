#!/usr/bin/ruby

require "date"

bench = ARGV.include? "--bench"
if ARGV[0] == "--bench"
    ARGV.shift
end

day = "day#{ARGV[0] || Date.today.day}"


if bench
    system "crystal build --release solution.cr", :chdir => day
    system "./solution", :chdir => day
    system "hyperfine ./solution", :chdir => day
else
    system "crystal solution.cr", :chdir => day
end